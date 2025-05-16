import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../auth_cubit/auth_cubit.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key, required this.isSignUp});
  final bool isSignUp;
  static bool obscureText = true;
  static bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSignUp)
            Padding(
              padding: const EdgeInsets.only(
                bottom: defaultPadding * 1.2,
              ),
              child: CustomTextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                hintStyle: context.textTheme.bodyMedium,
                autofillHints: const [AutofillHints.name],
                icon: Icons.person,
                placeholder: 'username'.tr(),
                maxLength: 32,
                controller: AuthCubit.get(context).usernameController,
              ),
            ),
          CustomTextField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            icon: Icons.email,
            hintStyle: context.textTheme.bodyMedium,
            placeholder: 'email'.tr(),
            maxLength: 32,
            controller: AuthCubit.get(context).emailController,
          ),
          const SizedBox(height: defaultPadding * 1.2),
          StatefulBuilder(
            builder: (context, setState) {
              return CustomTextField(
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(Icons.lock, color: AppColors.kPrimaryColor),
                obscureText: obscureText,
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => obscureText = !obscureText),
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color:
                        !obscureText ? AppColors.kPrimaryColor : Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
                hintStyle: context.textTheme.bodyMedium,
                placeholder: 'password'.tr(),
                maxLength: 32,
                controller: AuthCubit.get(context).passwordController,
              );
            },
          ),
        ],
      ),
    );
  }
}
