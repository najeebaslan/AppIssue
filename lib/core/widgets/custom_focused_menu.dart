import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class CustomFocusedMenuHolder extends StatelessWidget {
  const CustomFocusedMenuHolder({
    super.key,
    required this.child,
    required this.onPressed,
    required this.menuItems,
  });
  final Widget child;
  final Function onPressed;
  final List<FocusedMenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      menuItems: menuItems,
      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black54,
      openWithTap: false,
      menuOffset: 10.0,
      bottomOffsetHeight: 80.0,
      onPressed: onPressed,
      child: child,
    );
  }
}
