import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../theme/app_colors.dart';

class AdaptiveThemeContainer extends StatelessWidget {
  const AdaptiveThemeContainer({
    super.key,
    required this.child,
    this.enableBoxShadow = true,
    this.borderRadius,
    this.padding,
    this.height,
    this.border,
    this.width,
    this.margin,
    this.alignment,
  });
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool enableBoxShadow;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      alignment: alignment,
      padding: padding ?? EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(15.0),
        color: Colors.white,
        border: border,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).brightness == Brightness.light
              ? <Color>[
                  Colors.white,
                  const Color(0xfff1f1f1),
                ]
              : <Color>[
                  const Color(0xff1B2349),
                  const Color(0xff161A3A),
                ],
        ),
        boxShadow: _getBoxShadow(context),
      ),
      child: child,
    );
  }

  List<BoxShadow>? _getBoxShadow(BuildContext context) {
    if (enableBoxShadow) {
      return <BoxShadow>[
        if (context.isDark)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6.0,
          )
        else
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.2),
            offset: const Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
      ];
    } else {
      return null;
    }
  }
}
