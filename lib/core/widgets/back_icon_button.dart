import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

class CustomBackIconButton extends StatelessWidget {
  const CustomBackIconButton({
    super.key,
    this.color,
    this.onPressed,
    this.textDirection,
  });
  final Color? color;
  final VoidCallback? onPressed;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      child: MaterialButton(
        minWidth: 50.w,
        elevation: 0,
        padding: EdgeInsets.zero,
        onPressed: onPressed ?? () => Navigator.pop(context),
        shape: const CircleBorder(),
        color: context.themeData.iconTheme.color?.withValues(
          alpha: context.isDark ? 0.10 : 0.2,
        ),
        child: Icon(
          Icons.arrow_back_ios_sharp,
          color: context.customColors?.blackAndWhite?.withValues(alpha: 0.5),
          size: 18,
        ),
      ),
    );
  }
}
