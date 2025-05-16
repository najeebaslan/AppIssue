import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/utils/validate.dart';
import 'package:issue/core/widgets/custom_toast.dart';

import '../../../core/helpers/shared_prefs_service.dart';
import '../../../core/networking/type_response.dart';
import '../../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.authRepository,
    required this.userHelper,
  }) : super(AuthInitial());
  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  final AuthRepositoryImpl authRepository;
  final UserHelper userHelper;

  Future<void> _signInWithEmailAndPassword() async {
    emit(SignInLoading());

    final response = await authRepository.signInWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
    if (response is Success) {
      final user = response.success!;
      if (user.data()!.containsKey('profileImage')) {
        userHelper.saveImageUri(user.get('profileImage') ?? '');
      }
      await Future.wait([
        userHelper.saveUsername(user.get('name')),
        userHelper.saveEmail(user.get('email')),
        userHelper.saveIsUserSyncAccount(true),
      ]);
      emit(SignInSuccess());
    } else {
      emit(SignInError(response.failure.validate()));
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
    emit(SignUpLoading());

    final response = await authRepository.signUpWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
      usernameController.text.trim(),
    );
    if (response is Success) {
      await Future.wait([
        userHelper.saveUsername(usernameController.text.trim()),
        userHelper.saveEmail(emailController.text.trim()),
        userHelper.saveIsUserSyncAccount(true),
      ]);

      emit(SignUpSuccess());
    } else {
      emit(SignUpError(response.failure.validate()));
    }
  }

  Future<void> _resetPassword() async {
    emit(ResetPasswordLoading());

    final response = await authRepository.resetPassword(emailController.text.trim());
    if (response is Success) {
      emit(ResetPasswordSuccess());
    } else {
      emit(ResetPasswordError(response.failure.validate()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(RegisterWithGoogleLoading());

    final response = await authRepository.signInWithGoogle();
    if (response is Success) {
      final user = response.success;
      await userHelper.saveUsername(user?.displayName ?? '');
      await userHelper.saveImageUri(user?.photoURL ?? '');
      await userHelper.saveEmail(user?.email ?? '');
      await userHelper.saveIsUserSyncAccount(true);
      emit(RegisterWithGoogleSuccess());
    } else {
      emit(RegisterWithGoogleError(response.failure.validate()));
    }
  }

  //TODO: implementation apple integration
  Future<void> signInWithApple() async {
    emit(SignInLoading());

    final response = await authRepository.signInWithApple();
    if (response is Success) {
    } else {
      emit(RegisterWithGoogleError(response.failure.validate()));
    }
  }

  Future<void> signOut() async {
    emit(LoadingSignOutState());

    final response = await authRepository.signOut();
    if (response is Success) {
      await HelperSharedPreferences.clear();
      emit(SuccessSignOutState());
    } else {
      emit(ErrorSignOutState(response.failure.validate()));
    }
  }

  bool get validateEmail {
    if (emailController.text.isEmpty) {
      CustomToast.showErrorToast('emptyEmail'.tr());
      return false;
    } else if (!InputValidation().isValidEmail(emailController.text)) {
      CustomToast.showErrorToast('invalidEmail'.tr());
      return false;
    } else if (emailController.text.length < 6) {
      CustomToast.showErrorToast('lengthEmail'.tr());
      return false;
    }
    return true;
  }

  bool get validatePassword {
    if (passwordController.text.isEmpty) {
      CustomToast.showErrorToast('emptyPassword'.tr());
      return false;
    } else if (passwordController.text.length < 6) {
      CustomToast.showErrorToast('lengthPassword'.tr());
      return false;
    }
    return true;
  }

  bool get validateUsername {
    if (usernameController.text.isEmpty) {
      CustomToast.showErrorToast('emptyUsername'.tr());
      return false;
    } else if (usernameController.text.length < 6) {
      CustomToast.showErrorToast('lengthUsername'.tr());
      return false;
    }
    return true;
  }

  void validateThenSignIn() {
    if (validateEmail && validatePassword) _signInWithEmailAndPassword();
  }

  void validateThenSignUp() {
    if (validateEmail && validatePassword && validateUsername) _signUpWithEmailAndPassword();
  }

  void validateThenDoSendEmail() {
    if (validateEmail) _resetPassword();
  }

  void initController() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
  }

  void disposeController() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }
}
