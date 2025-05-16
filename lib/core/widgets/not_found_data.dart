import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../constants/app_icons.dart';

class NotFoundData extends StatelessWidget {
  final String? description;
  final String? error;
  final IconData? icon;
  final Widget? circleWidget;
  final double? radius;
  final double? errorFontSize;
  final double? descriptionFontSize;
  final Offset? offset;

  final Widget? customIcon;
  final EdgeInsetsGeometry? descriptionPadding;
  const NotFoundData({
    super.key,
    this.icon,
    this.error,
    this.offset,
    this.radius,
    this.customIcon,
    this.description,
    this.circleWidget,
    this.errorFontSize,
    this.descriptionFontSize,
    this.descriptionPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: offset ?? Offset.zero,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  circleWidget ??
                      CircleAvatar(
                        radius: radius ?? 70,
                        backgroundColor: context.themeData.primaryColor.withValues(alpha: 0.07),
                        child: customIcon ??
                            Icon(
                              icon ?? AppIcons.noData,
                              color: context.themeData.primaryColor.withValues(alpha: 0.7),
                              size: 100,
                            ),
                      ),
                  _circle(context: context, top: -20),
                  _circle(context: context, top: -20),
                  _circle(context: context, left: -20),
                  _circle(context: context, right: 0, top: 100),
                  _circle(context: context, right: 20, top: 120),
                ],
              ),
            ),
            if (!error.isEmptyOrNull)
              Text(
                error.validate(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: errorFontSize ?? 25.sp,
                  height: context.locale.isArabic ? 2 : 1.5,
                ),
              ),
            SizedBox(height: 5.h),
            Padding(
              padding: descriptionPadding ?? EdgeInsets.zero,
              child: Text(
                description.validate(),
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: const Color(0XFF95979A).withValues(alpha: 0.9),
                  fontSize: descriptionFontSize ?? (context.locale.isArabic ? 20.sp : 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _circle({
    double? top,
    double? right,
    double? left,
    double? bottom,
    required BuildContext context,
  }) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      bottom: bottom,
      child: Container(
        height: 9,
        width: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: context.themeData.primaryColor.withValues(alpha: 0.2),
            )
          ],
          gradient: LinearGradient(
            colors: [
              context.themeData.primaryColor.withValues(alpha: 0.5),
              context.themeData.primaryColor.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
