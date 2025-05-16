import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/data/models/accuse_model.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/alarms_days.dart';
import '../../accused/widgets/individual_alarm_control.dart';

class FilterListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final int index;
  final AccusedModel accused;

  const FilterListTile({
    super.key,
    required this.title,
    required this.index,
    required this.subtitle,
    required this.accused,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final remainingDays = _calculateRemainingDaysToThirdAlarm(accused);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
      child: Row(
        children: [
          leading,
          SizedBox(width: 16.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleWithStatusRow(context, remainingDays),
                SizedBox(height: 5.0.h),
                _buildCaseNumberText(context),
                _buildRemainingRow(context, remainingDays),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildTitleWithStatusRow(BuildContext context, int remainingDays) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            _formatFullName(title),
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              fontFamily: defaultFontFamilyMedium,
            ),
          ),
        ),
        buildStatusBox(context, remainingDays),
      ],
    );
  }

  Widget buildStatusBox(BuildContext context, int remainingDays) {
    final isStopped = AlarmStatusHelper().isStoppedCondition(accused);

    int remainingDaysFromLevel = AlarmsDays.calculateLavalDays(AlarmLevel.third) - remainingDays;

    String remainingResult = AlarmsDays.getLevelName(remainingDaysFromLevel);
    final alarmTypes = remainingResult == 'first'
        ? AlarmTypes.firstAlarm
        : remainingResult == 'second'
            ? AlarmTypes.nextAlarm
            : AlarmTypes.thirdAlert;
    final isDone = isDoneCondition(accused, alarmTypes);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ColoredBox(
        color: _getColorByAlarmType(alarmTypes: alarmTypes),
        child: SizedBox(
          width: 80.w,
          height: 25.h,
          child: Center(
            child: Text(
              getTitle(isStopped, isDone, remainingResult),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: _getColorByAlarmType(isLight: false, alarmTypes: alarmTypes),
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getTitle(bool isStopped, bool isDone, String remainingResult) {
    return isStopped
        ? "stopped".tr()
        : isDone
            ? 'durationCompleted'.tr()
            : remainingResult.tr();
  }

  bool isDoneCondition(AccusedModel accused, AlarmTypes alarmTypes) {
    return _calculateRemainingDaysToThirdAlarm(accused) == 0;
  }

  Text _buildCaseNumberText(BuildContext context) {
    return Text(
      '${'case_number'.tr()} ${accused.issueNumber}',
      style: context.textTheme.bodyMedium,
    );
  }

  LayoutBuilder _buildRemainingRow(BuildContext context, int remainingDays) {
    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth / 2),
            child: Text(
              '${'remaining'.tr()} $remainingDays ${'day'.tr()}',
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
                    subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.textTheme.bodySmall?.color,
                      fontSize: context.locale.isArabic ? 15.5.sp : 13.5.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5.w),
                const Icon(AppIcons.time, size: 20),
              ],
            ),
          ),
        ],
      );
    });
  }

  Color _getColorByAlarmType({bool isLight = true, required AlarmTypes alarmTypes}) {
    if (accused.isCompleted == 1 || _calculateRemainingDaysToThirdAlarm(accused) == 0) {
      return AppColors.errorDeepColor.withValues(alpha: isLight ? 0.1 : 1);
    }

    return (alarmTypes == AlarmTypes.firstAlarm
            ? AppColors.firstAlarmColor
            : alarmTypes == AlarmTypes.nextAlarm
                ? AppColors.nextAlarmColor
                : AppColors.thirdAlarmColor)
        .withValues(alpha: (isLight ? 0.1 : 1));
  }

  String _formatFullName(String fullName) {
    final nameSplit = fullName.split(' ');
    if (nameSplit.length == 1) return fullName;
    return nameSplit.length > 2
        ? '${nameSplit.first} ${nameSplit[1]} ${nameSplit.last}'
        : '${nameSplit.first} ${nameSplit.last}';
  }

  int _calculateRemainingDaysToThirdAlarm(AccusedModel accused) {
    final alarmDate = DateTime.parse(accused.date!)
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.third)));

    return DateTime.now().getRemainingDays(time: alarmDate);
  }
}
