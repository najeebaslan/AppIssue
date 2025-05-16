import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/features/auth/auth_cubit/auth_cubit.dart';

import '../../../../core/constants/assets_constants.dart';
import '../../../../core/router/routes_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../core/theme/theme.dart';
import '../widgets/background_for_gor_password.dart';
import '../widgets/forgot_password/forgot_passowrd_bloc_listener.dart';
import '../widgets/forgot_password/forgot_password_form.dart';
import '../widgets/forgot_password/switch_auth_views_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key, this.comingFromSignInView = true});
  final bool comingFromSignInView;
  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late AuthCubit _authCubit;
  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit.get(context);
    _authCubit.emailController = TextEditingController();
  }

  @override
  void dispose() {
    _authCubit.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundForGorPassword(
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(minWidth: 180.h, maxWidth: 600.w),
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: ForgotPasswordBlocListener(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * .05),
                    SvgPicture.asset(
                      ImagesConstants.forgotPassword,
                      height: 200.h,
                      width: 200.w,
                    ),
                    const SizedBox(height: defaultPadding * .8),
                    Text(
                      'forgotPassword'.tr(),
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.customColors?.blackAndWhite?.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * .2),
                    Text(
                      'forgotPasswordDescription'.tr(),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.customColors?.blackAndWhite?.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    ForgotPasswordForm(
                      emailController: _authCubit.emailController,
                    ),
                    const SizedBox(height: defaultPadding * 1.2),
                    CustomButton(
                      label: 'send',
                      onPressed: _authCubit.validateThenDoSendEmail,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    SwitchAuthViewsButton(
                      comingFromSignInView: widget.comingFromSignInView,
                      textDirection: material.TextDirection.rtl,
                      routeName: AppRoutesConstants.signInView,
                      label: 'rememberedPassword',
                      textButton: widget.comingFromSignInView ? 'signIn' : "back",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
