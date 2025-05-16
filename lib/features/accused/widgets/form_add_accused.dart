import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:issue/core/widgets/accused_input_field.dart';

import '../../../core/utils/validate.dart';

class FormAddAccused extends StatelessWidget {
  const FormAddAccused({
    super.key,
    required this.nameController,
    required this.issueController,
    required this.phoneController,
    required this.issueNumberController,
    required this.noteController,
  });

  final TextEditingController nameController;
  final TextEditingController issueController;
  final TextEditingController phoneController;
  final TextEditingController issueNumberController;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccusedInputField(
          maxLength: 80,
          hint: 'enterFllName',
          controller: nameController,
          validator: (value) => InputValidation.validationTextField(
            controller: nameController,
            error: 'pleaseEnterFllName'.tr(),
            lengthMinError: 'nameLengthMinError'.tr(),
            lengthMaxError: 'nameLengthMaxError'.tr(),
            main: 10,
            max: 80,
          ),
        ),
        AccusedInputField(
          hint: 'enterAccused',
          maxLength: 80,
          controller: issueController,
          validator: (value) => InputValidation.validationTextField(
            controller: issueController,
            error: 'pleaseEnterAccused'.tr(),
            lengthMinError: 'accusedLengthMinError'.tr(),
            lengthMaxError: 'accusedLengthMaxError'.tr(),
            main: 3,
            max: 80,
          ),
        ),
        AccusedInputField(
          hint: 'enterPhoneNumberAccusedAgent',
          controller: phoneController,
          textInputType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 9,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'pleaseEnterPhoneNumberAccusedAgent'.tr();
            }
            if (!RegExp(r'^\+?[0-9]{9,9}$').hasMatch(value)) {
              return 'notValidPhoneNumber'.tr();
            }
            return null;
          },
        ),
        AccusedInputField(
          hint: 'enterIssueNumber',
          controller: issueNumberController,
          textInputType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 20,
          validator: (value) {
            if (value != null && !RegExp(r'^\+?[0-9]{3,20}$').hasMatch(value)) {
              return 'notValidIssueNumber'.tr();
            }
            return InputValidation.validationTextField(
              controller: issueNumberController,
              error: 'pleaseEnterIssueNumber'.tr(),
              lengthMinError: 'issueNumberLengthMinError'.tr(),
              lengthMaxError: 'issueNumberLengthMaxError'.tr(),
              main: 3,
              max: 20,
            );
          },
        ),
        AccusedInputField(
          hint: 'enterNote',
          controller: noteController,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
