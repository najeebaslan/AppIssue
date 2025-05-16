import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/theme/app_colors.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/utils/alarms_days.dart';
import 'package:issue/core/widgets/adaptive_them_container.dart';
import 'package:issue/core/widgets/animations/animation_dialog.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

class IndividualAlarmControl extends StatelessWidget {
  final AlarmTypes alarmType;
  final bool isCompleted;
  final bool isStopped;
  final int remainingDays;
  final BuildContext context;
  final AccusedModel accused;

  const IndividualAlarmControl({
    super.key,
    required this.alarmType,
    required this.isCompleted,
    required this.isStopped,
    required this.remainingDays,
    required this.context,
    required this.accused,
  });

  @override
  Widget build(BuildContext context) {
    final String levelName = _getLevelName(alarmType);
    final bool isAlarmCompleted = remainingDays <= 1 || isCompleted;

    return AdaptiveThemeContainer(
      enableBoxShadow: false,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      border: Border.all(
        color: context.customColors!.blackAndWhite!.withValues(alpha: .5),
        width: 0.2,
      ),
      borderRadius: BorderRadius.circular(10.r),
      height: 50,
      child: Row(
        children: [
          _buildToggleButton(isAlarmCompleted, levelName),
          SizedBox(width: 10.w),
          _buildLevelText(levelName),
          const Spacer(),
          _buildRemainingDaysText(),
          SizedBox(width: 12.w),
          _buildStatusIcon(),
        ],
      ),
    );
  }

  RawMaterialButton _buildToggleButton(bool isAlarmCompleted, String levelName) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(Size(50.w, 50.h)),
      shape: const CircleBorder(),
      onPressed: isAlarmCompleted
          ? null
          : () {
              _showToggleDialog(levelName, isAlarmCompleted);
            },
      visualDensity: const VisualDensity(horizontal: -4),
      child: Icon(
        isAlarmCompleted ? AppIcons.pause : AppIcons.play,
        size: 29,
      ),
    );
  }

  void _showToggleDialog(String levelName, bool isAlarmCompleted) {
    final String action = isAlarmCompleted ? "enable" : "disable";
    context.awesomeDialog(
      color: AppColors.errorDeepColor,
      dialogType: CustomDialogType.warning,
      title: '${"doYouWant".tr()} ${action.tr()} ${_getOrderText(levelName)}',
      context: context,
      btnOkOnPress: () {
        BlocProvider.of<AccusedCubit>(context)
            .accuseDisableOrEnable(accused.id!, alarmType, !isAlarmCompleted);
      },
    );
  }

  RichText _buildLevelText(String levelName) {
    return RichText(
      text: TextSpan(
        text: context.locale.isArabic ? 'level'.tr() : levelName.tr(),
        style: context.textTheme.bodyMedium,
        children: [
          WidgetSpan(child: SizedBox(width: 5.w)),
          TextSpan(text: context.locale.isArabic ? levelName.tr() : 'level'.tr()),
        ],
      ),
    );
  }

  Text _buildRemainingDaysText() {
    final bool isDone = AlarmStatusHelper().isDoneCondition(accused, alarmType);
    return Text(
      isStopped
          ? "stopped".tr()
          : isDone
              ? 'durationCompleted'.tr()
              : "${"remaining".tr()} ${_getDayText(remainingDays)}",
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium?.copyWith(
        color: isStopped ? AppColors.errorDeepColor : _getStatusColor(),
      ),
    );
  }

  Color _getStatusColor() {
    return (alarmType == AlarmTypes.firstAlarm
                ? accused.firstAlarm == 1
                : alarmType == AlarmTypes.nextAlarm
                    ? accused.nextAlarm == 1
                    : accused.thirdAlert == 1) ||
            accused.isCompleted == 1 ||
            AlarmStatusHelper().calculateRemainingDaysToThirdAlarm(accused) == 0
        ? AppColors.successColor
        : context.textTheme.bodyMedium!.color!;
  }

  Icon _buildStatusIcon() {
    return AlarmStatusHelper().isDoneCondition(accused, alarmType)
        ? Icon(Icons.check_circle, size: defaultIconSize.w, color: AppColors.successColor)
        : const Icon(AppIcons.back);
  }

  String _getLevelName(AlarmTypes alarmType) {
    switch (alarmType) {
      case AlarmTypes.firstAlarm:
        return 'first';
      case AlarmTypes.nextAlarm:
        return 'second';
      case AlarmTypes.thirdAlert:
        return 'third';
      default:
        return '';
    }
  }

  String _getOrderText(String levelName) {
    return context.locale.isArabic
        ? "${"notice".tr()} ${levelName.tr()}"
        : "${levelName.tr()} ${"notice".tr()}";
  }

  String _getDayText(int remainingDays) {
    if (remainingDays == 1) return "day".tr();
    if (remainingDays <= 10) return '$remainingDays ${"days".tr()}';
    return '$remainingDays ${"day".tr()}';
  }
}

class AlarmStatusHelper {
  bool isDoneCondition(AccusedModel accused, AlarmTypes alarmType) {
    return alarmType == AlarmTypes.firstAlarm
        ? accused.firstAlarm == 1
        : alarmType == AlarmTypes.nextAlarm
            ? accused.nextAlarm == 1
            : accused.thirdAlert == 1 && calculateRemainingDaysToThirdAlarm(accused) == 0;
  }

  bool isStoppedCondition(AccusedModel accused) => accused.isCompleted == 1;

  int calculateRemainingDaysToThirdAlarm(AccusedModel accused) {
    final DateTime alarmDate = DateTime.parse(accused.date!)
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.third)));

    return DateTime.now().getRemainingDays(time: alarmDate);
  }
}
