import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../theme/app_colors.dart';

enum ButtonType { normal, warning }

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.customLabel,
    required this.onPressed,
    this.centerTitle = true,
    this.buttonType = ButtonType.normal,
    this.label,
    this.shape,
    this.padding,
    this.elevation,
    this.labelStyle,
    this.enable = true,
    this.backgroundColor,
    this.isUsingInDialog,
  });
  final VoidCallback? onPressed;
  final String? label;
  final bool centerTitle;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final bool? isUsingInDialog;
  final bool enable;
  final Widget? customLabel;

  final ButtonType buttonType;
  const CustomButton.warning({
    super.key,
    this.label,
    this.customLabel,
    this.onPressed,
    this.centerTitle = true,
    this.buttonType = ButtonType.warning,
    this.shape,
    this.labelStyle,
    this.padding,
    this.enable = true,
    this.elevation,
    this.backgroundColor,
    this.isUsingInDialog,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) => _controller.forward(),
      onPointerUp: (PointerUpEvent event) => _controller.reverse(),
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: widget.shape ?? const StadiumBorder(),
            elevation: widget.elevation ?? 10,
            padding: widget.padding ?? EdgeInsets.symmetric(vertical: 12.h),
            backgroundColor: widget.backgroundColor ?? getBackgroundColor,
            shadowColor: widget.backgroundColor != null
                ? widget.backgroundColor?.withValues(alpha: 0.35)
                : getBackgroundColor.withValues(alpha: 0.35),
          ),
          onPressed: widget.enable ? widget.onPressed : null,
          child: widget.centerTitle ? Center(child: _buildTitle()) : _buildTitle(),
        ),
      ),
    );
  }

  Color get getBackgroundColor {
    return widget.buttonType == ButtonType.warning
        ? AppColors.errorDeepColor
        : context.themeData.primaryColor;
  }

  Widget _buildTitle() {
    return widget.customLabel ??
        Text(
          widget.isUsingInDialog == true ? widget.label.validate() : widget.label.validate().tr(),
          textAlign: TextAlign.center,
          style: widget.labelStyle ??
              context.textTheme.titleLarge?.copyWith(
                color: AppColors.white,
              ),
        );
  }
}
