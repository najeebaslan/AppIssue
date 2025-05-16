import 'package:easy_localization/easy_localization.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/adaptive_them_container.dart';

enum NotificationCleanupOptions { daily, weekly, monthly }

class NotificationCleanup extends StatelessWidget {
  const NotificationCleanup({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveThemeContainer(
      width: context.width,
      height: 60.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconWithTitle(context),
          _buildSegmentedControl(context),
        ],
      ),
    );
  }

  Widget _buildIconWithTitle(BuildContext context) {
    return Row(
      children: [
        Badge(
          padding: EdgeInsets.only(
            top: 2,
            left: context.locale.isArabic ? 5 : 10,
          ),
          alignment: context.locale.isArabic ? Alignment.topRight : Alignment.topLeft,
          backgroundColor: Colors.transparent,
          label: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.isDark ? const Color(0xFF314595) : Colors.grey[400],
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Icon(
                FluentIcons.delete_20_filled,
                color: context.isDark ? const Color(0xff1B2349) : Colors.white,
                size: 11.5,
              ),
            ),
          ),
          child: const Icon(AppIcons.notifications, size: defaultIconSize),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'deleteNotifications'.tr(),
            style: context.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: StatefulBuilder(
        builder: (context, setState) {
          final userHelper = getIt.get<UserHelper>();
          final currentOption = userHelper.getNotificationCleanupOptions().name;
          return _segmentedControlOption(
            context: context,
            value: currentOption,
            onChanged: (String? value) {
              if (value != null) {
                NotificationCleanupOptions option;
                switch (value) {
                  case 'daily':
                    option = NotificationCleanupOptions.daily;
                    break;
                  case 'weekly':
                    option = NotificationCleanupOptions.weekly;
                    break;
                  default:
                    option = NotificationCleanupOptions.monthly;
                }
                userHelper.saveNotificationCleanupOptions(option);
                setState(() {}); // Refresh state
              }
            },
          );
        },
      ),
    );
  }

  Widget _segmentedControlOption({
    required void Function(String?) onChanged,
    required String value,
    required BuildContext context,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 150.w,
      ),
      child: CupertinoSlidingSegmentedControl<String>(
        padding: EdgeInsets.zero,
        thumbColor: context.themeData.primaryColor,
        children: {
          for (var option in NotificationCleanupOptions.values)
            option.name: Text(
              option.name.tr(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: value == option.name ? Colors.white : Colors.grey,
                fontSize: 11.sp,
              ),
            ),
        },
        groupValue: value,
        onValueChanged: onChanged,
      ),
    );
  }
}
