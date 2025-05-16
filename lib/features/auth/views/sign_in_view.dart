import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/router/routes_constants.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../auth_cubit/auth_cubit.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_form.dart';
import '../widgets/is_have_account.dart';
import '../widgets/register_with_third_party.dart';
import '../widgets/sign_in_bloc_listener.dart';
import '../widgets/title_auth.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late AuthCubit _authCubit;
  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit.get(context);
    _authCubit.initController();
  }

  @override
  void dispose() {
    _authCubit.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgroundWithTitle(
        paddingButtonOnOpenKeyword: context.viewInsets.bottom,
        child: SignInBlocListener(
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleAuth(title: 'signIn'),
                    const SizedBox(height: defaultPadding * 0.2),
                    const AuthForm(isSignUp: false),
                    const SizedBox(height: defaultPadding * 0.2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutesConstants.forgotPasswordView,
                          arguments: true,
                        ),
                        borderRadius: BorderRadius.circular(15.r),
                        child: Text(
                          'forgotPassword'.tr(),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.customColors?.blackAndWhite,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 1.2),
                    CustomButton(
                      onPressed: _authCubit.validateThenSignIn,
                      label: 'signIn',
                    ),
                    SizedBox(height: context.height * 0.02),
                    RegisterWithThirdParty(
                      onTapGoogle: _authCubit.signInWithGoogle,
                      onTapApple: _authCubit.signInWithApple,
                    ),
                    SizedBox(height: context.height * 0.04),
                    const IsHaveAccount(isSignIn: true),
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
