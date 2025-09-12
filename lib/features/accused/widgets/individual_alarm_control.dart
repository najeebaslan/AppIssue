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

// Main Widget Class
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
    return AlarmViewModel(
      alarmType: alarmType,
      isCompleted: isCompleted,
      isStopped: isStopped,
      remainingDays: remainingDays,
      context: context,
      accused: accused,
    ).buildAlarmControl();
  }
}

// ViewModel to handle business logic
class AlarmViewModel {
  final AlarmTypes alarmType;
  final bool isCompleted;
  final bool isStopped;
  final int remainingDays;
  final BuildContext context;
  final AccusedModel accused;
  final AlarmStatusHelper _statusHelper = AlarmStatusHelper();

  AlarmViewModel({
    required this.alarmType,
    required this.isCompleted,
    required this.isStopped,
    required this.remainingDays,
    required this.context,
    required this.accused,
  });

  Widget buildAlarmControl() {
    return AdaptiveThemeContainer(
      enableBoxShadow: false,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      border: Border.all(
        color: context.customColors!.blackAndWhite!.withValues(alpha: .5),
        width: 0.2,
      ),
      borderRadius: BorderRadius.circular(10.r),
      height: 50.w,
      child: Row(
        children: [
          AlarmToggleButton(viewModel: this),
          SizedBox(width: 10.w),
          AlarmLevelText(viewModel: this),
          const Spacer(),
          AlarmRemainingDaysText(viewModel: this),
          SizedBox(width: 12.w),
          AlarmStatusIcon(viewModel: this),
        ],
      ),
    );
  }

  String get levelName {
    switch (alarmType) {
      case AlarmTypes.firstAlarm:
        return 'first';
      case AlarmTypes.nextAlarm:
        return 'second';
      case AlarmTypes.thirdAlert:
        return 'third';
      case AlarmTypes.isCompleted:
        return '';
    }
  }

  bool get isAlarmCompleted => remainingDays <= 1 || isCompleted;
  bool get isDone =>
      _statusHelper.isDoneCondition(accused, alarmType) ||
      _statusHelper.calculateRemainingDaysToThirdAlarm(accused) == 0 ||
      remainingDays == 0;

  Color get statusColor {
    final isActive = (alarmType == AlarmTypes.firstAlarm
            ? accused.firstAlarm == 1 &&
                _statusHelper.calculateRemainingDaysToFirstAlarm(accused) == 0
            : alarmType == AlarmTypes.nextAlarm
                ? accused.nextAlarm == 1 &&
                    _statusHelper.calculateRemainingDaysToSecondAlarm(accused) == 0
                : accused.thirdAlert == 1 &&
                    _statusHelper.calculateRemainingDaysToThirdAlarm(accused) == 0) ||
        accused.isCompleted == 1 ||
        remainingDays == 0 ||
        _statusHelper.calculateRemainingDaysToThirdAlarm(accused) == 0;

    return isActive ? AppColors.successColor : context.textTheme.bodyMedium!.color!;
  }

  String get dayText {
    if (remainingDays == 1) return "day".tr();
    if (remainingDays <= 10) return '$remainingDays ${"days".tr()}';
    return '$remainingDays ${"day".tr()}';
  }

  String get orderText {
    return context.locale.isArabic
        ? "${"notice".tr()} ${levelName.tr()}"
        : "${levelName.tr()} ${"notice".tr()}";
  }
}

// Toggle Button Component
class AlarmToggleButton extends StatelessWidget {
  final AlarmViewModel viewModel;

  const AlarmToggleButton({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(Size(50.w, 50.h)),
      shape: const CircleBorder(),
      onPressed: viewModel.isAlarmCompleted ? null : _handleToggle,
      visualDensity: const VisualDensity(horizontal: -4),
      child: Icon(
        viewModel.isAlarmCompleted ? AppIcons.pause : AppIcons.play,
        size: 29.w,
      ),
    );
  }

  void _handleToggle() {
    final action = viewModel.isAlarmCompleted ? "enable" : "disable";
    viewModel.context.awesomeDialog(
      color: AppColors.errorDeepColor,
      dialogType: CustomDialogType.warning,
      title: '${"doYouWant".tr()} ${action.tr()} ${viewModel.orderText}',
      context: viewModel.context,
      btnOkOnPress: () {
        BlocProvider.of<AccusedCubit>(viewModel.context).accuseDisableOrEnable(
          viewModel.accused.id!,
          viewModel.alarmType,
          !viewModel.isAlarmCompleted,
        );
      },
    );
  }
}

// Level Text Component
class AlarmLevelText extends StatelessWidget {
  final AlarmViewModel viewModel;

  const AlarmLevelText({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: viewModel.context.locale.isArabic ? 'level'.tr() : viewModel.levelName.tr(),
        style: viewModel.context.textTheme.bodyMedium,
        children: [
          WidgetSpan(child: SizedBox(width: 5.w)),
          TextSpan(
            text: viewModel.context.locale.isArabic ? viewModel.levelName.tr() : 'level'.tr(),
          ),
        ],
      ),
    );
  }
}

// Remaining Days Text Component
class AlarmRemainingDaysText extends StatelessWidget {
  final AlarmViewModel viewModel;

  const AlarmRemainingDaysText({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final (text, color) = _getTextAndColor();

    return Text(
      text,
      textAlign: TextAlign.center,
      style: viewModel.context.textTheme.bodyMedium?.copyWith(color: color),
    );
  }

  (String, Color) _getTextAndColor() {
    if (viewModel.isStopped || viewModel.isCompleted) {
      return ("stopped".tr(), AppColors.errorDeepColor);
    }
    if (viewModel.isDone) {
      return ('durationCompleted'.tr(), AppColors.successColor);
    }
    return ("${"remaining".tr()} ${viewModel.dayText}", viewModel.statusColor);
  }
}

// Status Icon Component
class AlarmStatusIcon extends StatelessWidget {
  final AlarmViewModel viewModel;

  const AlarmStatusIcon({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(),
      size: defaultIconSize.w,
      color: viewModel.isStopped || viewModel.isCompleted ? Colors.red : viewModel.statusColor,
    );
  }

  IconData _getIcon() {
    if (viewModel.isDone || viewModel.remainingDays == 0) {
      return viewModel.accused.isCompleted == 1 ? Icons.cancel : Icons.check_circle;
    }
    return AppIcons.back;
  }
}

// Helper Class
class AlarmStatusHelper {
  bool isDoneCondition(AccusedModel accused, AlarmTypes alarmType) {
    return alarmType == AlarmTypes.firstAlarm
        ? accused.firstAlarm == 1 && calculateRemainingDaysToFirstAlarm(accused) == 0
        : alarmType == AlarmTypes.nextAlarm
            ? accused.nextAlarm == 1 && calculateRemainingDaysToSecondAlarm(accused) == 0
            : accused.thirdAlert == 1 && calculateRemainingDaysToThirdAlarm(accused) == 0;
  }

  bool isStoppedCondition(AccusedModel accused) => accused.isCompleted == 1;

  int calculateRemainingDaysToThirdAlarm(AccusedModel accused) {
    final DateTime alarmDate = DateTime.parse(accused.date!)
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.third)));
    return DateTime.now().getRemainingDays(time: alarmDate);
  }

  int calculateRemainingDaysToSecondAlarm(AccusedModel accused) {
    final DateTime alarmDate = DateTime.parse(accused.date!)
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.next)));
    return DateTime.now().getRemainingDays(time: alarmDate);
  }

  int calculateRemainingDaysToFirstAlarm(AccusedModel accused) {
    final DateTime alarmDate = DateTime.parse(accused.date!)
        .add(Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.next)));
    return DateTime.now().getRemainingDays(time: alarmDate);
  }
}
