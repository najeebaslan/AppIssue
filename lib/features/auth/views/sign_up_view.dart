import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_button.dart';

import '../../../core/theme/theme.dart';
import '../auth_cubit/auth_cubit.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_form.dart';
import '../widgets/is_have_account.dart';
import '../widgets/register_with_third_party.dart';
import '../widgets/sign_up_bloc_listener.dart';
import '../widgets/title_auth.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
        child: SignUpBlocListener(
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleAuth(title: 'signUp'),
                    const AuthForm(isSignUp: true),
                    const SizedBox(height: defaultPadding * 1.2),
                    CustomButton(
                      onPressed: _authCubit.validateThenSignUp,
                      label: 'signUp',
                    ),
                    SizedBox(height: context.height * 0.02),
                    RegisterWithThirdParty(
                      onTapGoogle: _authCubit.signInWithGoogle,
                      onTapApple: _authCubit.signInWithApple,
                    ),
                    SizedBox(height: context.height * 0.04),
                    const IsHaveAccount(isSignIn: false),
                    SizedBox(height: context.height * 0.02),
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
