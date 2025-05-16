import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/back_icon_button.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.size,
    this.title,
    this.customAppBar,
    this.onClickBack,
    this.useCustomBackIconButton = true,
  });
  final Size size;
  final Widget? title;
  final Widget? customAppBar;
  final VoidCallback? onClickBack;
  final bool? useCustomBackIconButton;

  @override
  Widget build(BuildContext context) {
    if (customAppBar != null) return customAppBar!;

    return AppBar(
      title: title,
      elevation: 0,
      leading:
          useCustomBackIconButton == true ? CustomBackIconButton(onPressed: onClickBack) : null,
      backgroundColor: context.themeData.appBarTheme.backgroundColor,
    );
  }

  @override
  Size get preferredSize => size;

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}
