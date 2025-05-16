import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/widgets/percent_indicator.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../accused_details_view.dart';

class ChartCircleAlarms extends StatelessWidget {
  final List<DateTime> alarmDates;
  final List<int> totalAlarmDays;
  final List<double> fadeInValues;

  const ChartCircleAlarms({
    super.key,
    required this.alarmDates,
    required this.totalAlarmDays,
    required this.fadeInValues,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccusedCubit, AccusedState>(
      buildWhen: (previous, current) => current is SetState,
      builder: (context, state) {
        return AdaptiveThemeContainer(
          enableBoxShadow: false,
          margin: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          border: Border.all(
            color: context.customColors!.blackAndWhite!.withValues(alpha: .5),
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(10.r),
          child: Column(
            children: List.generate(totalAlarmDays.length, (index) {
              return FadeInAnimation(
                opacity: fadeInValues[2 + index],
                child: _RemainingCharts(
                  alarmDate: alarmDates[index].toString(),
                  remainingDays: DateTime.now().getRemainingDays(
                    time: alarmDates[index],
                  ),
                  title: ['first'.tr(), 'second'.tr(), 'third'.tr()][index],
                  totalAlarmDays: totalAlarmDays[index],
                  color: [
                    AppColors.firstAlarmColor,
                    AppColors.nextAlarmColor,
                    AppColors.thirdAlarmColor
                  ][index],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _RemainingCharts extends StatelessWidget {
  const _RemainingCharts({
    required this.remainingDays,
    required this.title,
    required this.totalAlarmDays,
    required this.color,
    required this.alarmDate,
  });

  final int remainingDays;
  final String title;
  final int totalAlarmDays;
  final Color color;
  final String alarmDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: [
          _dotedWithAlarmType(context),
          _alarmFormatDate(context),
          SizedBox(width: 30.w),
          _circularPercentIndicator(context),
        ],
      ),
    );
  }

  Expanded _circularPercentIndicator(BuildContext context) {
    return Expanded(
      flex: 0,
      child: SizedBox(
        height: 30.h,
        child: CircularPercentIndicator(
          backgroundColor: _getColor(context),
          lineWidth: 3,
          radius: 25.h,
          animation: true,
          animationDuration: 1000,
          percent: _getPercentAlarm(remainingDays, totalAlarmDays),
          progressColor: color,
        ),
      ),
    );
  }

  Expanded _alarmFormatDate(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Text(
        style: context.textTheme.bodyMedium,
        alarmDate.formatDate(
          languageCode: context.locale.languageCode,
        ),
      ),
    );
  }

  Expanded _dotedWithAlarmType(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          SizedBox(width: 10.w),
          Text(title, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Color _getColor(BuildContext context) {
    return context.isDark ? Colors.white.withValues(alpha: 0.1) : color.withValues(alpha: 0.3);
  }

  double _getPercentAlarm(int remainingDays, int totalAlarmDays) {
    return (remainingDays - totalAlarmDays.toDouble()) /
        totalAlarmDays.toDouble() *
        360.0.abs() *
        -1;
  }
}
