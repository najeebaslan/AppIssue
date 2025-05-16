import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/features/accused/widgets/individual_alarm_control.dart';

import '../../../core/utils/alarms_days.dart';
import '../../../data/models/accuse_model.dart';
import '../accused_details_view.dart';

class AlarmControlPanel extends StatelessWidget {
  final List<DateTime> alarmDates;
  final List<int> totalAlarmDays;
  final List<double> fadeInValues;
  final AccusedModel accused;

  const AlarmControlPanel({
    super.key,
    required this.alarmDates,
    required this.accused,
    required this.totalAlarmDays,
    required this.fadeInValues,
  });

  @override
  Widget build(BuildContext context) {
    return _buildAlarmControls(context);
  }

  Widget _buildAlarmControls(BuildContext context) {
    final List<AlarmTypes> alarmTypes = [
      AlarmTypes.firstAlarm,
      AlarmTypes.nextAlarm,
      AlarmTypes.thirdAlert,
    ];

    final List<int> alarmStates = [
      accused.firstAlarm!,
      accused.nextAlarm!,
      accused.thirdAlert!,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: DefaultTextStyle(
        style: context.textTheme.bodyMedium!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            FadeInAnimation(
              opacity: fadeInValues[5],
              child: Text(
                'stopAlarms'.tr(),
                style: context.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 7),
            ...List.generate(totalAlarmDays.length, (index) {
              return FadeInAnimation(
                opacity: fadeInValues[6 + index],
                child: IndividualAlarmControl(
                  alarmType: alarmTypes[index],
                  isStopped: accused.isCompleted == 1,
                  isCompleted: alarmStates[index] == 1,
                  remainingDays: DateTime.now().getRemainingDays(time: alarmDates[index]),
                  context: context,
                  accused: accused,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

