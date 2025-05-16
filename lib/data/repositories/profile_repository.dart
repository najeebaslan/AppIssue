import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/networking/type_response.dart';

import '../../core/constants/default_settings.dart';
import '../../core/networking/handel_firebase_errors.dart';
import '../../core/networking/network_info.dart';
import '../../core/services/services_locator.dart';
import '../../core/widgets/image/upload_image.dart';
import '../models/profile_model.dart';

abstract class BaseProfileRepository {
  Future<ResponseResult<String, ProfileModel>> getProfile(String userId);
  Future<ResponseResult<String, OnUpdateSuccess>> updateProfile(UpdateProfileParameters parameters);
  Future<ResponseResult<String, String>> updateImage(UpdateImageParameters parameters);
  Future<ResponseResult<String, bool>> deleteMyAccount(String? imageUri, String password);

  /// This method was created to adapt old users found in [Version: 1.0.0+1]
  /// because the first version for application it's not save user profile in
  /// [FirebaseFirestore] so check if user not exist, sync user data to [FirebaseFirestore]
  Future<ResponseResult<String, bool>> isUserExisted(String userID);
}

class ProfileRepositoryImpl extends BaseProfileRepository {
  final FirebaseFirestore firebaseFireStore;
  final NetworkInfo networkInfo;
  final FirebaseStorage firebaseStorage;
  static const String _userCollection = DefaultSettings.nameCollectionUsersInFirebase;

  ProfileRepositoryImpl({
    required this.firebaseFireStore,
    required this.networkInfo,
    required this.firebaseStorage,
  });

  @override
  Future<ResponseResult<String, ProfileModel>> getProfile(String userId) async {
    final docRef = firebaseFireStore.collection(_userCollection).doc(userId);
    try {
      return await docRef.get().then((value) {
        if (value.exists) {
          final model = ProfileModel.fromMap(value.data()!);
          return Success(model);
        } else {
          return Failure('profileNotFound'.tr());
        }
      });
    } on FirebaseException catch (error) {
      return Failure(FirebaseErrorHandler.filterError(error));
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<ResponseResult<String, OnUpdateSuccess>> updateProfile(
      UpdateProfileParameters parameters) async {
    try {
      Map<String, dynamic> data = {};
      if (parameters.name != null) data['name'] = parameters.name;

      if (await networkInfo.isConnected) {
        firebaseFireStore.collection(_userCollection).doc(parameters.userId).update(data);
        return Success(OnUpdateSuccess(name: data['name']));
      } else {
        return Failure(SocketException('noInternet'.tr()).message);
      }
    } catch (error) {
      return Failure(FirebaseErrorHandler.filterError(error));
    }
  }

  @override
  Future<ResponseResult<String, bool>> deleteMyAccount(String? imageUri, String password) async {
    try {
      User? user = getIt.get<FirebaseAuth>().currentUser;

      if (await networkInfo.isConnected && user != null) {
        String email = user.email!;
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        if (!imageUri.isEmptyOrNull) {
          await firebaseStorage.refFromURL(imageUri!).delete();
        }
        await firebaseFireStore.collection(_userCollection).doc(user.uid).delete();

        await user.delete();
        return Success(true);
      } else {
        return Failure(SocketException('noInternet'.tr()).message);
      }
    } catch (error) {
      return Failure(FirebaseErrorHandler.filterError(error));
    }
  }

  @override
  Future<ResponseResult<String, String>> updateImage(UpdateImageParameters parameters) async {
    try {
      Map<String, dynamic> data = {};

      if (await networkInfo.isConnected) {
        if (parameters.newImageFile != null) {
          final imageUri = await UploadFiles().uploadImage(parameters.newImageFile!);
          if (imageUri is Success) {
            data['profileImage'] = imageUri.success;
            if (parameters.oldImageUri.isEmptyOrNull == false) {
              await firebaseStorage.refFromURL(parameters.oldImageUri!).delete();
            }
            firebaseFireStore.collection(_userCollection).doc(parameters.userId).update(data);

            return Success(imageUri.success.validate());
          } else {
            return Failure(imageUri.failure.toString());
          }
        } else {
          return Failure('errorNotFoundImage'.tr());
        }
      } else {
        return Failure(SocketException('noInternet'.tr()).message);
      }
    } catch (error) {
      return Failure(FirebaseErrorHandler.filterError(error));
    }
  }

  @override
  Future<ResponseResult<String, bool>> isUserExisted(String userID) async {
    try {
      if (await networkInfo.isConnected) {
        final docRef = firebaseFireStore.collection(_userCollection).doc(userID);
        DocumentSnapshot snapshot = await docRef.get();

        if (snapshot.exists) {
          return Success(true);
        } else {
          return Failure('User not found');
        }
      } else {
        return Failure(SocketException('noInternet'.tr()).message);
      }
    } catch (error) {
      return Failure(FirebaseErrorHandler.filterError(error));
    }
  }
}

class UpdateProfileParameters {
  final String userId;
  final String? name;

  UpdateProfileParameters({required this.userId, this.name});
}

class UpdateImageParameters {
  final String userId;
  final File? newImageFile;
  final String? oldImageUri;
  UpdateImageParameters({required this.userId, this.newImageFile, this.oldImageUri});
}

class OnUpdateSuccess {
  final String? imageUri;
  final String? name;
  OnUpdateSuccess({this.imageUri, this.name});
}
