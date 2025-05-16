import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/data/data_base/db_helper.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/helpers/helper_user.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../data/models/data_trial_mode.dart';
import 'highlight_painter.dart';

class TrialModeOverlay extends StatefulWidget {
  const TrialModeOverlay({super.key});

  @override
  State<TrialModeOverlay> createState() => _TrialModeOverlayState();
}

class _TrialModeOverlayState extends State<TrialModeOverlay> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> hoverAnimation;

  final GlobalKey generateWidgetKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (getIt.get<UserHelper>().isUserInTrialMode() && mounted) {
          showOverly(context);
        }
      });
    });
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    hoverAnimation = Tween(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.06),
    ).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void closeOverlayEntry() {
    if (_overlayEntry?.mounted ?? false) {
      _overlayEntry?.remove();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (getIt.get<UserHelper>().isUserInTrialMode()) {
      return TextButton(
        key: generateWidgetKey,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          visualDensity: const VisualDensity(horizontal: -4, vertical: -2),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
        onPressed: () async {
          await getIt.get<DBHelper>().addDataTest(DataTrialMode.data);
          if (context.mounted) {
            context.read<AccusedCubit>().getAccused();
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 15.h, bottom: 8.h, right: 8.w, left: 8.w),
          child: Text(
            'enableTrialMode'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              height: 0.1,
              color: context.themeData.primaryColor,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void showOverly(BuildContext context) {
    final RenderBox renderBox = generateWidgetKey.currentContext?.findRenderObject() as RenderBox;
    closeOverlayEntry(); // Close any existing overlay

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () => closeOverlayEntry(),
          child: Stack(
            children: [
              Container(
                width: context.mediaQuery.size.width,
                height: context.mediaQuery.size.height,
                color: Colors.transparent,
              ),
              RepaintBoundary(
                child: CustomPaint(
                  painter: HighlightPainter(
                    highlightSize: renderBox.size,
                    highlightPosition: renderBox.localToGlobal(Offset.zero),
                    highlightRadius: 5.r,
                    screenSize: context.mediaQuery.size,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: renderBox.localToGlobal(Offset.zero).dy + renderBox.size.height + 5,
                        left: renderBox.localToGlobal(Offset.zero).dx / 2,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.transparent,
                          child: SlideTransition(
                            position: hoverAnimation,
                            child: AdaptiveThemeContainer(
                              borderRadius: BorderRadius.circular(10.r),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 12.w,
                              ),
                              child: Stack(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: context.textTheme.titleMedium,
                                      text: 'enableTrialMode'.tr(),
                                      children: [
                                        TextSpan(
                                          text: 'enableTrialModeDescription'.tr(),
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: context.locale.isArabic ? 0 : null,
                                    right: context.locale.isArabic ? null : 0,
                                    child: InkWell(
                                      onTap: () => closeOverlayEntry(),
                                      child: Icon(
                                        AppIcons.close,
                                        color: context.customColors?.blackAndWhite,
                                        size: 17,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}
