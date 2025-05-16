import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_toast.dart';

import '../../../../core/router/routes_constants.dart';
import '../../../../core/widgets/animations/animation_dialog.dart';
import '../../auth_cubit/auth_cubit.dart';

class ForgotPasswordBlocListener extends StatelessWidget {
  const ForgotPasswordBlocListener({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is ResetPasswordLoading ||
          current is ResetPasswordError ||
          current is ResetPasswordSuccess,
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          context.showLoading();
        } else if (state is ResetPasswordSuccess) {
          context.hideLoading();
          CustomToast.showDefaultToast('weAreSendLinkToYourEmail'.tr());
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutesConstants.signInView,
            (route) => false,
          );
        } else if (state is ResetPasswordError) {
          context.hideLoading();
          context.awesomeDialog(
            context: context,
            title: state.error,
            dialogType: CustomDialogType.error,
          );
        }
      },
      child: child,
    );
  }
}
