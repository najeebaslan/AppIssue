import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/base_divider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/alarms_days.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../data/models/accuse_model.dart';
import 'circle_charts_alarm.dart';
import 'line_chart_alarm.dart';

class AccusedDetailsCardContent extends StatelessWidget {
  const AccusedDetailsCardContent({
    super.key,
    required this.accused,
    this.enableContainerShadow = true,
  });
  final AccusedModel accused;
  final bool enableContainerShadow;
  @override
  Widget build(BuildContext context) {
    final firstAlarmDate = DateTime.parse(accused.date.toString())
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.first)));

    final nextAlarmDate = DateTime.parse(accused.date.toString())
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.next)));

    final thirdAlarmDate = DateTime.parse(accused.date.toString())
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.third)));

    return AdaptiveThemeContainer(
      width: context.width,
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.only(bottom: 10.h),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding.w,
                vertical: 10.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _AccusedTitles(accused)),
                  CircleChartsAlarm(
                    remainingDays: DateTime.now().getRemainingDays(
                      time: thirdAlarmDate,
                    ),
                  ),
                ],
              ),
            ),
            const BaseDivider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: 5.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLineChartAlarm(
                    AlarmLevel.first,
                    context.locale.isArabic
                        ? '${'notice'.tr()} ${"first".tr()}'
                        : '${'first'.tr()} ${"notice".tr()}',
                    firstAlarmDate,
                    AppColors.firstAlarmColor,
                  ),
                  _buildLineChartAlarm(
                    AlarmLevel.next,
                    context.locale.isArabic
                        ? '${'notice'.tr()} ${"second".tr()}'
                        : '${'second'.tr()} ${"notice".tr()}',
                    nextAlarmDate,
                    AppColors.nextAlarmColor,
                  ),
                  _buildLineChartAlarm(
                    AlarmLevel.third,
                    context.locale.isArabic
                        ? '${'notice'.tr()} ${"third".tr()}'
                        : '${'third'.tr()} ${"notice".tr()}',
                    thirdAlarmDate,
                    AppColors.thirdAlarmColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChartAlarm(AlarmLevel level, String title, DateTime alarmDate, Color color) {
    return LineChartAlarm(
      alarmLevel: level,
      title: title,
      alarmDate: alarmDate,
      lineBackgroundColor: color.withValues(alpha: 0.2),
      strongLineBackgroundColor: LinearGradient(
        colors: [color.withValues(alpha: 0.7), color],
      ),
    );
  }
}

class _AccusedTitles extends StatelessWidget {
  const _AccusedTitles(this.accused);
  final AccusedModel accused;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${accused.name}',
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleMedium?.copyWith(
            fontFamily: defaultFontFamilyMedium,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          '${"entry_date".tr()}:${accused.date?.formatDate(
            languageCode: context.locale.languageCode,
          )}',
          style: textStyle,
        ),
        SizedBox(height: 2.h),
        RichText(
          text: TextSpan(
            text: '${'condemnation'.tr()}:',
            children: [
              WidgetSpan(child: SizedBox(width: 2.w)),
              TextSpan(text: accused.accused),
              WidgetSpan(child: SizedBox(width: 5.w)),
              TextSpan(text: '${'classifiedByNumber'.tr()} ${accused.issueNumber}'),
            ],
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
