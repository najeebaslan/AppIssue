import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/router/routes_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/alarms_days.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../data/models/notification_model.dart';

class ListViewNotifications extends StatelessWidget {
  const ListViewNotifications({super.key, required this.notificationAdapter});
  final List<NotificationAdapter> notificationAdapter;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: defaultPadding.h),
      itemCount: notificationAdapter.length,
      itemBuilder: (context, index) {
        final notification = notificationAdapter[index];

        return AdaptiveThemeContainer(
          enableBoxShadow: false,
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: defaultPadding.w),
          child: ListTile(
            dense: true,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutesConstants.accusedDetailsView,
              arguments: notification.accusedModel,
            ),
            leading: CircleAvatar(
              backgroundColor:
                  getColorByAlarmType(alarmTypes: notification.notificationModel.alarmType),
              child: Text(
                getLevelName(
                  adapterFromAlarmTypesToAlarmLevel[notification.notificationModel.alarmType]!,
                ).tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: context.locale.isArabic ? null : 10.sp,
                  color: getColorByAlarmType(
                    alarmTypes: notification.notificationModel.alarmType,
                    isLight: false,
                  ),
                ),
              ),
            ),
            isThreeLine: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.accusedModel.name.validate(),
                  textAlign: TextAlign.right,
                  style: context.textTheme.bodyLarge,
                ),
                Text(
                  getTitleNotification(
                    alarmLevel: adapterFromAlarmTypesToAlarmLevel[
                        notification.notificationModel.alarmType]!,
                    dateAccused: DateTime.parse(notification.accusedModel.date.validate()),
                  ),
                  maxLines: 2,
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
            subtitle: buildRemainingRow(
              context: context,
              accusedDate: DateTime.parse(notification.accusedModel.date.validate()),
              notificationDate: DateTime.parse(
                notification.notificationModel.notificationDate.validate(),
              ),
            ),
          ),
        );
      },
    );
  }

  ConstrainedBox customRawMaterialButton({
    required IconData icon,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(36.w, 40.h)),
      child: AspectRatio(
        aspectRatio: 1.9 / 2,
        child: RawMaterialButton(
          onPressed: onPressed,
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: context.customColors!.blackAndWhite!, width: 0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          fillColor: context.customColors?.backgroundTextField,
          child: Icon(
            icon,
            size: defaultIconSize - 4,
            color: context.customColors!.blackAndWhite?.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  LayoutBuilder buildRemainingRow({
    required BuildContext context,
    required DateTime accusedDate,
    required DateTime notificationDate,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth / 2),
            child: Text(
              '${'since'.tr()} ${intl.DateFormat.yMd(context.locale.languageCode).format(accusedDate)}',
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium,
            ),
          ),
          const Spacer(),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    intl.DateFormat.yMd().format(notificationDate),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: context.locale.isArabic ? null : 13.5.sp,
                      color: context.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5.w),
                const Icon(AppIcons.alertUrgent, size: 20),
              ],
            ),
          ),
        ],
      );
    });
  }

  String getLevelName(AlarmLevel alarmLevel) {
    if (alarmLevel == AlarmLevel.first) {
      return 'first';
    } else if (alarmLevel == AlarmLevel.next) {
      return 'second';
    } else {
      return 'third';
    }
  }

  Color getColorByAlarmType({bool isLight = true, required AlarmTypes alarmTypes}) {
    return (alarmTypes == AlarmTypes.firstAlarm
            ? AppColors.firstAlarmColor
            : alarmTypes == AlarmTypes.nextAlarm
                ? AppColors.nextAlarmColor
                : AppColors.thirdAlarmColor)
        .withValues(alpha: (isLight ? 0.1 : 1));
  }

  String getTitleNotification({required AlarmLevel alarmLevel, required DateTime dateAccused}) {
    return '${"alarmWillEnd".tr()} ${getLevelName(alarmLevel).tr()} '
        '${getDeferenceExpiredDate(dateAccused, alarmLevel)} ';
  }

  String getDeferenceExpiredDate(DateTime dateAccused, AlarmLevel alarmLevel) {
    final difference = calculateRemainingDaysToThirdAlarm(dateAccused, alarmLevel);

    if (difference.toString().startsWith('-') || difference == 0) {
      return 'today'.tr();
    } else {
      return 'afterOneDay'.tr();
    }
  }

  int calculateRemainingDaysToThirdAlarm(DateTime dateTime, AlarmLevel alarmLevel) {
    final alarmDate = dateTime.add(Duration(days: AlarmsDays.calculateLavalDays(alarmLevel)));

    final resultRemainingDays = DateTime.now().getRemainingDays(time: alarmDate);
    return resultRemainingDays;
  }

  static Map<AlarmTypes, AlarmLevel> adapterFromAlarmTypesToAlarmLevel = {
    AlarmTypes.firstAlarm: AlarmLevel.first,
    AlarmTypes.nextAlarm: AlarmLevel.next,
    AlarmTypes.thirdAlert: AlarmLevel.third,
  };
}
