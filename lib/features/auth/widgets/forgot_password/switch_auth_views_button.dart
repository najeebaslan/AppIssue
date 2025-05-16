import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import '../../../../core/router/routes_manager.dart';

class SwitchAuthViewsButton extends StatelessWidget {
  final String label;
  final String routeName;
  final String textButton;
  final VoidCallback? onTap;
  final bool comingFromSignInView;
  final TextDirection? textDirection;
  const SwitchAuthViewsButton({
    super.key,
    this.onTap,
    this.textDirection,
    required this.label,
    this.routeName = '',
    required this.textButton,
    required this.comingFromSignInView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: textDirection ?? TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 10.w),
        Text(
          label.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(width: 5.w),
        InkWell(
          onTap: onTap ??
              () {
                if (routeName.isEmpty) {
                  AppRouter.unknownRouteScreen();
                } else {
                  comingFromSignInView
                      ? Navigator.pushReplacementNamed(context, routeName)
                      : Navigator.pop(context);
                }
              },
          child: Text(
            textButton.tr(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.customColors?.blackAndWhite,
            ),
          ),
        ),
      ],
    );
  }
}
