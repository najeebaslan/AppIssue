import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../../../core/networking/handel_firebase_errors.dart';
import '../../../core/networking/network_info.dart';
import '../../../core/networking/type_response.dart';
import '../../../core/services/services_locator.dart';
import '../../core/constants/default_settings.dart';
import '../../core/helpers/shared_prefs_service.dart';
import '../../core/widgets/image/file_service.dart';

class DeleteAccountRepos {
  final FirebaseFirestore fireStore;
  final NetworkInfo networkInfo;
  final GoogleSignIn googleSignIn;
  final FirebaseAuth auth;

  DeleteAccountRepos({
    required this.fireStore,
    required this.networkInfo,
    required this.googleSignIn,
    required this.auth,
  });

  static const String _profileCollection = DefaultSettings.nameCollectionUsersInFirebase;
  static final currentUser = getIt.get<FirebaseAuth>().currentUser;

  Future<ResponseResult<String, bool>> deleteAccount(
      {String? password, String? profileImage}) async {
    try {
      if (!await networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }

      if (currentUser != null) {
        await reauthenticate(currentUser!, password);

        await _deleteUserProfile(profileImage, currentUser!);

        await HelperSharedPreferences.clear();
        return Success(true);
      } else {
        return Failure('user not found');
      }
    } catch (error) {
      log(error.toString());
      return Failure(FirebaseErrorHandler.filterError(error));
    }
  }

  Future<void> reauthenticate(User user, String? password) async {
    if (isSignInWithApple) {
      await reauthenticateWithApple();
    } else if (isSignInWithGoogle) {
      await reauthenticateWithGoogle();
    } else {
      if (password == null) throw "Password required for email authentication";
      await _reauthenticateWithCredential(user, password);
    }
  }

  Future<void> _reauthenticateWithCredential(User user, String password) async {
    final credential = EmailAuthProvider.credential(email: user.email!.trim(), password: password);
    await user.reauthenticateWithCredential(credential);
  }

  Future<void> _deleteUserProfile(String? profileImage, User user) async {
    try {
      if (!profileImage.isEmptyOrNull) {
        final deleteResult = await FileService().deleteFile(profileImage!);
        if (deleteResult is Failure) {
          // Log the error but continue with account deletion
          debugPrint('Failed to delete profile image: ${deleteResult.failure}');
        }
      }
      await fireStore.collection(_profileCollection).doc(user.uid).delete();
      await user.delete();
    } catch (e) {
      // Ensure user.delete() is attempted even if other operations fail
      await user.delete().catchError((_) {});
      rethrow;
    }
  }

  Future<void> reauthenticateWithGoogle() async {
    User? user = auth.currentUser;

    if (user == null) {
      throw "User is not signed in."; // User should be signed in to delete account
    }

    // Initiate Google Sign-In to get fresh credentials
    GoogleSignInAccount? googleUser =
        await googleSignIn.signInSilently(); // Use signInSilently to avoid prompting for login
    if (googleUser == null) throw "something is wrong, please try again";

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await user.reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateWithApple() async {
    final appleProvider = AppleAuthProvider();
    final user = auth.currentUser;
    if (user == null) throw "User not signed in";

    await user.reauthenticateWithProvider(appleProvider);
  }

  bool get isSignInUsingGoogleOrApple {
    return (isSignInWithGoogle || isSignInWithApple) ? true : false;
  }

  bool get isSignInWithApple {
    return currentUser?.providerData.any((data) => data.providerId == 'apple.com') ?? false;
  }

  bool get isSignInWithGoogle {
    return currentUser?.providerData.any((data) => data.providerId == 'google.com') ?? false;
  }
}
