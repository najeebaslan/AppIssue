import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';

class ListTileSetting extends StatelessWidget {
  const ListTileSetting({
    super.key,
    this.status,
    this.isLogoutButton = false,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String? status;
  final VoidCallback onTap;
  final bool isLogoutButton;
  @override
  Widget build(BuildContext context) {
    Color? color = isLogoutButton ? AppColors.errorDeepColor : null;
    return InkWell(
      borderRadius: BorderRadius.circular(15.0.r),
      onTap: onTap,
      child: Ink(
        width: context.width,
        height: 60.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0.r),
          color: Colors.white,
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
          boxShadow: <BoxShadow>[
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
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                title.tr(),
                style: context.textTheme.bodyMedium?.copyWith(color: color),
              ),
            ),
            const Spacer(),
            if (status != null)
              Text(
                status!.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 13.sp,
                  color: color,
                ),
              ),
            Icon(AppIcons.back, color: color),
          ],
        ),
      ),
    );
  }
}
