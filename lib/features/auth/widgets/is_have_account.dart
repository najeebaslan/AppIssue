import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/router/routes_constants.dart';
import '../auth_cubit/auth_cubit.dart';

class IsHaveAccount extends StatelessWidget {
  const IsHaveAccount({super.key, required this.isSignIn});
  final bool isSignIn;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: !isSignIn ? 'alreadyHaveAccount'.tr() : 'noHaveAccount'.tr(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                    letterSpacing: -0.2,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5.w)),
                TextSpan(
                  text: isSignIn ? 'signUp'.tr() : 'signIn'.tr(),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.customColors?.blackAndWhite,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacementNamed(
                        context,
                        isSignIn ? AppRoutesConstants.signUpView : AppRoutesConstants.signInView,
                      );
                    },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
