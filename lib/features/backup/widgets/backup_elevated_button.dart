import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

class BackUpElevatedButton extends StatelessWidget {
  const BackUpElevatedButton({
    super.key,
    required this.borderSide,
    required this.onPressed,
    required this.imageUri,
    required this.title,
    this.radioWidget,
    this.backgroundColor,
  });

  final BorderSide borderSide;
  final VoidCallback onPressed;
  final String imageUri;
  final String title;
  final Widget? radioWidget;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? Colors.transparent,
        ),
        shape: WidgetStateProperty.all(
          ContinuousRectangleBorder(
            side: borderSide,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.all(5),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5.h,
              horizontal: 12.w,
            ),
            child: Image.asset(
              imageUri,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            title.tr(),
            style: context.textTheme.bodyMedium,
          ),
          const Spacer(),
          radioWidget ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
