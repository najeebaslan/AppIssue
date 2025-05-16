import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';

import '../../../core/router/routes_constants.dart';
import '../../../core/widgets/animations/animation_dialog.dart';
import '../auth_cubit/auth_cubit.dart';

class SignUpBlocListener extends StatelessWidget {
  const SignUpBlocListener({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is SignUpLoading ||
          current is SignUpError ||
          current is SignUpSuccess ||
          current is RegisterWithGoogleLoading ||
          current is RegisterWithGoogleSuccess ||
          current is RegisterWithGoogleError,
      listener: (context, state) {
        if (state is SignUpLoading || state is RegisterWithGoogleLoading) {
          context.showLoading();
        } else if (state is SignUpSuccess || state is RegisterWithGoogleSuccess) {
          context.hideLoading();
          getIt.get<UserHelper>().saveUserLoggedIn(true);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutesConstants.navigationBar,
            (route) => false,
          );
        } else if (state is SignUpError || state is RegisterWithGoogleError) {
          context.hideLoading();
          String error = '';
          if (state is RegisterWithGoogleError) {
            error = state.error;
          } else if (state is SignUpError) {
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
