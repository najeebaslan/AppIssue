import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final IconData? icon;
  final int maxLength;
  final int? maxLines;
  final bool obscureText;
  final String placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final TextStyle? hintStyle;
  final void Function()? onTap;
  final TextStyle? textFieldStyle;
  final EdgeInsetsGeometry? padding;
  final bool transparentBackgroundColor;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextAlignVertical textAlignVertical;
  final BoxConstraints? prefixIconConstraints;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? borderColor;
  final Function(String value)? onFieldSubmitted;
  final BorderRadius? borderRadius;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? enabledBorder;

  const CustomTextField({
    this.textAlignVertical = TextAlignVertical.center,
    this.transparentBackgroundColor = false,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.done,
    super.key,
    this.autofillHints,
    this.prefixIconConstraints,
    required this.placeholder,
    this.obscureText = false,
    required this.maxLength,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.textFieldStyle,
    this.maxLines = 1,
    this.borderRadius,
    this.enabledBorder,
    this.borderColor,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    this.onChanged,
    this.autoFocus,
    this.validator,
    this.fillColor,
    this.padding,
    this.onTap,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      autocorrect: false,
      focusNode: focusNode,
      autofocus: autoFocus ?? false,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onTap: onTap,
      inputFormatters: inputFormatters,
      controller: controller,
      textAlign: textAlign,
      maxLines: maxLines,
      textAlignVertical: textAlignVertical,
      cursorColor: context.customColors?.blackAndWhite,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onFieldSubmitted: onFieldSubmitted,
      style: textFieldStyle ?? context.textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding: context.isTablet ? null : padding ?? EdgeInsets.symmetric(vertical: 13.h),
        counterText: '',
        fillColor: fillColor ??
            (context.isDark ? const Color(0xff1B2349) : Colors.grey.withValues(alpha: 0.1)),
        suffixIcon: suffixIcon,
        prefixIcon:
            prefixIcon ?? (icon == null ? null : Icon(icon, color: AppColors.kPrimaryColor)),
        hintText: placeholder,
        prefixIconConstraints: prefixIconConstraints,
        hintStyle: hintStyle ??
            context.textTheme.titleLarge?.copyWith(
              fontSize: 14.sp,
              color: context.isDark ? AppColors.white : AppColors.black.withValues(alpha: 0.7),
            ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(30),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(30),
        ),
        errorStyle: const TextStyle(height: 1),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(30.r),
            ),
        focusedBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.grey.withValues(alpha: 0.1),
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(30),
            ),
      ),
    );
  }
}
