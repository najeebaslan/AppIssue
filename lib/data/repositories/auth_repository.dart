import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:issue/core/networking/handel_firebase_errors.dart';
import 'package:issue/core/networking/network_info.dart';
import 'package:issue/core/networking/type_response.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../core/constants/default_settings.dart';
import '../../core/constants/error_messages_constants.dart';
import '../../core/utils/enums.dart';
import '../models/profile_model.dart';

abstract class BaseAuthRepository {
  Future<ResponseResult<AuthFailuresEnum, DocumentSnapshot<Map<String, dynamic>>>>
      signInWithEmailAndPassword(String email, String password);
  Future<ResponseResult<String, User>> signUpWithEmailAndPassword(
      String email, String password, String username);
  Future<ResponseResult<String, User>> signInWithGoogle();
  Future<ResponseResult<String, ProfileModel>> signInWithApple([String? username]);
  Future<ResponseResult<String, void>> resetPassword(String email);
  Future<ResponseResult<String, void>> signOut();
}

class AuthRepositoryImpl implements BaseAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFireStore,
    required NetworkInfo networkInfo,
  })  : _firebaseAuth = firebaseAuth,
        _fireStore = firebaseFireStore,
        _networkInfo = networkInfo;

  @override
  Future<ResponseResult<AuthFailuresEnum, DocumentSnapshot<Map<String, dynamic>>>>
      signInWithEmailAndPassword(String email, String password) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure(AuthFailuresEnum.noInternet);
      }
      final userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) return Failure(AuthFailuresEnum.firebaseError);
      DocumentSnapshot<Map<String, dynamic>> user = await _getUser(userCredential.user!.uid);

      if (!user.exists) {
        await _saveUser(user.id, '', email);
        DocumentSnapshot<Map<String, dynamic>> updatedUser =
            await _getUser(userCredential.user!.uid);

        return Success(updatedUser);
      }

      return Success(user);
    } on FirebaseAuthException catch (_) {
      return Failure(AuthFailuresEnum.firebaseError);
    } catch (error) {
      return Failure(AuthFailuresEnum.catchError);
    }
  }

  Future<void> _saveUser(String uid, String name, String email) async {
    await _fireStore
        .collection(DefaultSettings.nameCollectionUsersInFirebase)
        .doc(uid)
        .set({'name': name.trim(), 'email': email.trim()});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUser(String userId) async {
    final user = await _fireStore
        .collection(DefaultSettings.nameCollectionUsersInFirebase)
        .doc(userId)
        .get();
    return user;
  }

  @override
  Future<ResponseResult<String, User>> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await _saveUser(userCredential.user!.uid, username, email);

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    } catch (error) {
      return Failure(error.toString());
    }
  }

  @override
  Future<ResponseResult<String, User>> signInWithGoogle() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return Failure("Unknown error GoogleSignIn, please retry again.");
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final providers = userCredential.user?.providerData.map((p) => p.providerId).toList();
      if (providers?.contains('apple.com') == true) {
        await userCredential.user?.unlink(providers![providers.indexOf('google.com')]);
        return Failure('email already exist');
      }
      if (userCredential.user == null) {
        return Failure("Unknown error FirebaseAuth, please retry again.");
      }
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    } catch (e) {
      return Failure(ErrorMessages.unknownError);
    }
  }

  // @override
//   Future<ResponseResult<String, ProfileModel>> signInWithApple([String? username]) async {
//     try {
//       if (!await _networkInfo.isConnected) {
//         return Failure('noInternet'.tr());
//       }
//       // AuthorizationCredentialAppleID appleCredential = await getAppleCredential();
//       // final oAuthCredential = OAuthProvider('apple.com').credential(
//       //   accessToken: appleCredential.authorizationCode,
//       //   idToken: appleCredential.identityToken,
//       // );
//       // final userCredential = await _firebaseAuth.signInWithCredential(oAuthCredential);
//       AppleAuthProvider appleProvider = AppleAuthProvider();

//       appleProvider = appleProvider.addScope('email');

// // add optional 'name' scope
//       appleProvider = appleProvider.addScope('name');

// // show the Apple sign in UI
//       final userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
//       if (userCredential.user == null) {
//         return Failure("Unknown error FirebaseAuth, please retry again.");
//       }
//       final providers = userCredential.user?.providerData.map((p) => p.providerId).toList();
//       if (providers?.contains('google.com') == true) {
//         await userCredential.user?.unlink(providers![providers.indexOf('apple.com')]);
//         return Failure('email already exist');
//       }

//       return Success(
//         ProfileModel(
//           name: userCredential.user?.displayName ?? '',
//           email: userCredential.user!.email ?? '',
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       log(e.toString());
//       return Failure(FirebaseErrorHandler.filterError(e));
//     } catch (e) {
//       log(e.toString());
//       return Failure(ErrorMessages.unknownError);
//     }
//   }
  @override
  Future<ResponseResult<String, ProfileModel>> signInWithApple([String? username]) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      AuthorizationCredentialAppleID appleCredential = await getAppleCredential();
      final oAuthCredential = OAuthProvider('apple.com').credential(
        accessToken: appleCredential.authorizationCode,
        idToken: appleCredential.identityToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(oAuthCredential);

      if (userCredential.user == null) {
        return Failure("Unknown error FirebaseAuth, please retry again.");
      }
      final providers = userCredential.user?.providerData.map((p) => p.providerId).toList();
      if (providers?.contains('google.com') == true) {
        await userCredential.user?.unlink(providers![providers.indexOf('apple.com')]);
        return Failure('email already exist');
      }

      return Success(
        ProfileModel(
          name: userCredential.user?.displayName ?? '',
          email: userCredential.user!.email ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      return Failure(FirebaseErrorHandler.filterError(e));
    } catch (e) {
      log(e.toString());
      return Failure(ErrorMessages.unknownError);
    }
  }

  Future<AuthorizationCredentialAppleID> getAppleCredential() async {
    if (Platform.isIOS) {
      // iOS doesn't need webAuthenticationOptions
      return await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
    } else {
      // Android requires webAuthenticationOptions
      return await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        // webAuthenticationOptions: WebAuthenticationOptions(
        //   clientId: '	najeeb.aslan.issueservices',
        //   redirectUri: Uri.parse('https://your-domain.com/callbacks/sign_in_with_apple'),
        // ),
      );
    }
  }

  @override
  Future<ResponseResult<String, void>> resetPassword(String email) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return Success(null);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    }
  }

  @override
  Future<ResponseResult<String, void>> signOut() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      await _firebaseAuth.signOut();
      return Success(null);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    }
  }
}
