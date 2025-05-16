import 'package:flutter/material.dart';
import 'package:issue/core/extensions/context_extension.dart';

class BaseDivider extends StatelessWidget {
  const BaseDivider({super.key, this.thickness, this.padding});
  final double? thickness;
  final double? padding;
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: padding ?? (context.isDark ? 0 : 1.0),
      thickness: thickness ?? 0.4,
      color: context.customColors?.dividerColor,
    );
  }
}
