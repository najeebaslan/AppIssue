import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_text_field.dart';

class AccusedInputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType textInputType;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const AccusedInputField({
    super.key,
    required this.hint,
    this.controller,
    this.textInputAction,
    this.maxLength,
    this.inputFormatters,
    this.textInputType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: CustomTextField(
        textInputAction: textInputAction ?? TextInputAction.next,
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        borderRadius: BorderRadius.circular(30),
        placeholder: hint.tr(),
        hintStyle: context.textTheme.bodyMedium,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        maxLength: maxLength ?? 40,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
