import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../../../core/utils/alarms_days.dart';

class LineChartAlarm extends StatelessWidget {
  const LineChartAlarm({
    super.key,
    required this.title,
    required this.alarmDate,
    required this.alarmLevel,
    required this.lineBackgroundColor,
    required this.strongLineBackgroundColor,
  });
  final String title;
  final DateTime alarmDate;
  final AlarmLevel alarmLevel;
  final Color lineBackgroundColor;
  final LinearGradient strongLineBackgroundColor;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: context.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.normal,
        fontSize: 15.sp,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: context.textTheme.bodyMedium),
          Container(
            height: 4.h,
            width: 70.w,
            margin: EdgeInsets.only(top: 5.h),
            decoration: BoxDecoration(
              color: lineBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
            ),
            child: Wrap(
              children: <Widget>[
                Container(
                  width: GetWidthFromRemainingDays(
                    remainingDays: DateTime.now().getRemainingDays(
                      time: alarmDate,
                    ),
                    baseWidth: 70,
                    alarmLevel: alarmLevel,
                  ).getWidth().w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    gradient: strongLineBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(4.0.r)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              alarmDate.toString().formatDate(languageCode: context.locale.languageCode),
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class GetWidthFromRemainingDays {
  final int remainingDays;
  final int baseWidth;
  final AlarmLevel alarmLevel;

  GetWidthFromRemainingDays({
    required this.remainingDays,
    required this.baseWidth,
    required this.alarmLevel,
  });

  double getWidth() {
    int levelDays = AlarmsDays.calculateLavalDays(alarmLevel);
    return ((remainingDays - levelDays) / levelDays * baseWidth.abs() * -1).abs();
  }
}
