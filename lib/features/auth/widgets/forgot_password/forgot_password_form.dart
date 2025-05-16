import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../../core/widgets/custom_text_field.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key, required this.emailController});
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              maxLength: 32,
              icon: Icons.email,
              controller: emailController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              hintStyle: context.textTheme.bodyMedium,
              autofillHints: const [AutofillHints.email],
              placeholder: 'enterEmail'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
