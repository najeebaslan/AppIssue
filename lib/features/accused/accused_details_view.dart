import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/router/routes_constants.dart';
import 'package:issue/core/widgets/adaptive_them_container.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/alarms_days.dart';
import '../../core/widgets/back_icon_button.dart';
import '../../data/models/accuse_model.dart';
import '../home/widgets/accused_details_card_content.dart';
import '../home/widgets/base_hero_flip_animation.dart';
import 'widgets/accused_agent.dart';
import 'widgets/chart_circle_alarms.dart';
import 'widgets/alarm_control_panel.dart';
import 'widgets/popup_menu_details_accused.dart';

class AccusedDetailsView extends StatefulWidget {
  const AccusedDetailsView({super.key, required this.accusedModel});
  final AccusedModel accusedModel;
  @override
  State<AccusedDetailsView> createState() => _AccusedDetailsViewState();
}

class _AccusedDetailsViewState extends State<AccusedDetailsView> {
  late List<double> _fadeInValues;
  final int _fadeInDuration = 70;
  late AccusedCubit _accusedCubit;
  late AccusedModel accused;
  @override
  void initState() {
    super.initState();

    _accusedCubit = context.read<AccusedCubit>();
    accused = widget.accusedModel;
    _accusedCubit = BlocProvider.of<AccusedCubit>(context);
    _fadeInValues = List<double>.filled(9, 0.0);
    _fadeInItems();
  }

  void _fadeInItems() {
    for (int i = 0; i < _fadeInValues.length; i++) {
      Future.delayed(Duration(milliseconds: i * _fadeInDuration), () {
        if (mounted) {
          setState(() => _fadeInValues[i] = 1.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAlarmDays = [
      AlarmsDays.calculateLavalDays(AlarmLevel.first),
      AlarmsDays.calculateLavalDays(AlarmLevel.next),
      AlarmsDays.calculateLavalDays(AlarmLevel.third),
    ];

    final alarmDates = totalAlarmDays.map((days) {
      return DateTime.parse(accused.date.toString()).add(
        Duration(days: days),
      );
    }).toList();

    final textStyle = context.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 15.sp,
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          context.read<AccusedCubit>().updatedAccused = accused;
          true;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding.w - 10),
          child: BlocListener<AccusedCubit, AccusedState>(
            listenWhen: (previous, current) => current is SetState,
            listener: (context, state) {
              if (state is SetState) {
                state.accused != null ? setState(() => accused = state.accused!) : setState(() {});
              }
            },
            child: DefaultTextStyle(
              style: textStyle,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseHeroFlipAnimation(
                      heroTag: accused.id.toString(),
                      addMaterial: false,
                      child: AccusedDetailsCardContent(
                        accused: accused,
                        enableContainerShadow: false,
                      ),
                    ),
                    FadeInAnimation(
                      opacity: _fadeInValues[0],
                      child: AccusedAgent(
                        accused: accused,
                      ),
                    ),
                    FadeInAnimation(
                      opacity: _fadeInValues[1],
                      child: ChartCircleAlarms(
                        alarmDates: alarmDates,
                        totalAlarmDays: totalAlarmDays,
                        fadeInValues: _fadeInValues,
                      ),
                    ),
                    FadeInAnimation(
                      opacity: _fadeInValues[5],
                      child: AlarmControlPanel(
                        accused: accused,
                        alarmDates: alarmDates,
                        totalAlarmDays: totalAlarmDays,
                        fadeInValues: _fadeInValues,
                      ),
                    ),
                    if (!accused.note.isEmptyOrNull)
                      FadeInAnimation(
                        opacity: _fadeInValues[8],
                        child: _buildNotice(
                          accused.note.validate(),
                        ),
                      ),
                    SizedBox(height: defaultPadding.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      leading: CustomBackIconButton(
        onPressed: () {
          context.read<AccusedCubit>().updatedAccused = accused;
          Navigator.pop(context);
        },
      ),
      title: Text(
        'accusedDetails'.tr(),
        style: context.textTheme.titleLarge,
      ),
      actions: [
        PopupMenuDetailsAccused(
          accusedCubit: _accusedCubit,
          accused: accused,
          onEditOnTap: () async {
            final isUpdateAccused = await Navigator.pushNamed(
              context,
              AppRoutesConstants.addAccusedView,
              arguments: accused,
            );
            if (isUpdateAccused != null && context.mounted) {
              setState(() => accused = isUpdateAccused as AccusedModel);
            }
          },
        ),
      ],
    );
  }

  Widget _buildNotice(String notice) {
    return AdaptiveThemeContainer(
      alignment: Alignment.centerRight,
      enableBoxShadow: false,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      border: Border.all(
        color: context.customColors!.blackAndWhite!.withValues(alpha: .5),
        width: 0.2,
      ),
      borderRadius: BorderRadius.circular(10.r),
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          const Icon(AppIcons.notepad),
          SizedBox(width: 12.w),
          Text(
            accused.note.validate(),
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
            ),
          )
        ],
      ),
    );
  }
}

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final double opacity;

  const FadeInAnimation({
    super.key,
    required this.child,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }
}
