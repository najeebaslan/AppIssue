import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/app_colors.dart';

class BackgroundForGorPassword extends StatelessWidget {
  const BackgroundForGorPassword({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final secondPrimaryColor = context.customColors?.backgroundColorCircle?.withValues(alpha: 0.4);
    return Stack(
      children: [
        Positioned(
          top: -50.h,
          right: -90.w,
          child: CircleAvatar(
            radius: 110.r,
            backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: -30.h,
          right: -65.w,
          child: CircleAvatar(
            radius: 110.r,
            backgroundColor: secondPrimaryColor,
          ),
        ),
        Positioned(
          top: -70.h,
          left: -85.w,
          child: CircleAvatar(
            radius: 110.r,
            backgroundColor: AppColors.kPrimaryColor.withValues(alpha: 0.1),
          ),
        ),
        StarIcons(
          color: AppColors.kPrimaryColor.withValues(alpha: 0.5),
          iconSize: 20,
          top: 70.h,
          left: (85.w) / 1.5,
        ),
        Positioned(
          bottom: -220.h,
          left: -110.w,
          child: Container(
            height: 470.h,
            width: 160.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: secondPrimaryColor!,
                width: 15.w,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -30.h,
          left: -70.w,
          child: Icon(
            Icons.wifi_tethering_sharp,
            size: 100.w,
            color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
          ),
        ),
        child
      ],
    );
  }
}

class StarIcons extends StatelessWidget {
  const StarIcons({
    super.key,
    this.color,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.iconSize,
    this.child,
  });
  final Color? color;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? iconSize;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: child ??
          Icon(
            Icons.star,
            size: iconSize ?? 10,
            color: color ?? AppColors.kPrimaryColor.withValues(alpha: 0.5),
          ),
    );
  }
}
