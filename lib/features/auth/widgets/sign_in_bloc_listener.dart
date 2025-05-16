import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/helpers/helper_user.dart';
import '../../../core/router/routes_constants.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/widgets/animations/animation_dialog.dart';
import '../auth_cubit/auth_cubit.dart';

class SignInBlocListener extends StatelessWidget {
  const SignInBlocListener({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is SignInLoading ||
          current is SignInError ||
          current is SignInSuccess ||
          current is RegisterWithGoogleLoading ||
          current is RegisterWithGoogleSuccess ||
          current is RegisterWithGoogleError,
      listener: (context, state) {
        if (state is SignInLoading || state is RegisterWithGoogleLoading) {
          context.showLoading();
        } else if (state is SignInSuccess || state is RegisterWithGoogleSuccess) {
          context.hideLoading();
          getIt.get<UserHelper>().saveUserLoggedIn(true);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutesConstants.navigationBar,
            (route) => false,
          );
        } else if (state is SignInError || state is RegisterWithGoogleError) {
          context.hideLoading();
          String error = '';
          if (state is RegisterWithGoogleError) {
            error = state.error;
          } else if (state is SignInError) {
            error = state.error;
          }
          context.awesomeDialog(
            context: context,
            title: error,
            dialogType: CustomDialogType.error,
          );
        }
      },
      child: child,
    );
  }
}
