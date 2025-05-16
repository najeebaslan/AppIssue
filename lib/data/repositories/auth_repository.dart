import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:issue/core/networking/handel_firebase_errors.dart';
import 'package:issue/core/networking/network_info.dart';
import 'package:issue/core/networking/type_response.dart';

import '../../core/constants/default_settings.dart';

abstract class BaseAuthRepository {
  Future<ResponseResult<String, DocumentSnapshot<Map<String, dynamic>>>> signInWithEmailAndPassword(
      String email, String password);
  Future<ResponseResult<String, User>> signUpWithEmailAndPassword(
      String email, String password, String username);
  Future<ResponseResult<String, User>> signInWithGoogle();
  Future<ResponseResult<String, void>> signInWithApple();
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
  Future<ResponseResult<String, DocumentSnapshot<Map<String, dynamic>>>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return Failure('User not found');
      DocumentSnapshot<Map<String, dynamic>> user = await _getUser(userCredential);

      if (!user.exists) {
        await _saveUser(userCredential, email);
        DocumentSnapshot<Map<String, dynamic>> user = await _getUser(userCredential);

        return Success(user);
      }

      return Success(user);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    }
  }

  Future<void> _saveUser(UserCredential userCredential, String email) async {
    await _fireStore
        .collection(DefaultSettings.nameCollectionUsersInFirebase)
        .doc(userCredential.user?.uid)
        .set({'name': userCredential.user?.displayName?.trim(), 'email': email.trim()});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUser(UserCredential userCredential) async {
    final user = await _fireStore
        .collection(DefaultSettings.nameCollectionUsersInFirebase)
        .doc(userCredential.user?.uid)
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
      _saveUser(userCredential, email);

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
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
      if (userCredential.user == null) {
        return Failure("Unknown error FirebaseAuth, please retry again.");
      }
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    } catch (e) {
      return Failure('Unknown error');
    }
  }

  @override
  Future<ResponseResult<String, void>> signInWithApple() async {
    try {
      if (!await _networkInfo.isConnected) {
        return Failure('noInternet'.tr());
      }
      // await SignInWithApple.getAppleIDCredential(scopes: [
      //   AppleIDAuthorizationScopes.email,
      //   AppleIDAuthorizationScopes.fullName,
      // ]);
      return Success(null);
    } on FirebaseAuthException catch (e) {
      return Failure(FirebaseErrorHandler.filterError(e));
    } catch (e) {
      return Failure('Unknown error');
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
