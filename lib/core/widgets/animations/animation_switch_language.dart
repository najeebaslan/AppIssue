import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';

import '../../utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';

class AnimationSwitchLanguage extends StatefulWidget {
  const AnimationSwitchLanguage({super.key});

  @override
  State<AnimationSwitchLanguage> createState() => _AnimationSwitchLanguageState();
}

class _AnimationSwitchLanguageState extends State<AnimationSwitchLanguage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> rotateCircleLanguage;
  late Animation<Offset> translateCircleLanguage;
  double width = 45.w;
  double height = 47.h;
  bool isExpand = false;
  late LanguageType selectedLanguage;

  void _onTap() {
    _controller.isForwardOrCompleted ? _controller.reverse() : _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _initializeSelectedLanguage();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    rotateCircleLanguage = Tween<double>(begin: 0.0, end: math.pi * 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    translateCircleLanguage =
        Tween<Offset>(begin: const Offset(0, 0), end: Offset(53.w, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
  }

  void _initializeSelectedLanguage() {
    if (getIt.get<UserHelper>().getAppLanguage().startsWith('ar')) {
      selectedLanguage = LanguageType.arabic;
    } else {
      selectedLanguage = LanguageType.english;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFlag(String imageUri) {
    return SizedBox(
      height: 40.h,
      width: 40.w,
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: SvgPicture.asset(imageUri),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: height,
      width: width,
      onEnd: () => _onEndAnimatedContainer(),
      curve: Curves.fastOutSlowIn,
      transformAlignment: Alignment.center,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: isExpand
            ? Border.all(
                color: context.customColors!.blackAndWhite!.withValues(alpha: 0.5),
              )
            : null,
      ),
      duration: const Duration(milliseconds: 700),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: translateCircleLanguage.value,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateZ(rotateCircleLanguage.value),
                      child: GestureDetector(
                        onTap: () {
                          selectedLanguage =
                              context.locale.isArabic ? LanguageType.english : LanguageType.arabic;
                          _onOpenOrCloseContainer();
                        },
                        child: _buildFlag(
                          context.locale.isArabic
                              ? ImagesConstants.unitedStateFlag
                              : ImagesConstants.saudiArabiaFlag,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () => _onOpenOrCloseContainer(),
                child: _buildFlag(
                  context.locale.isArabic
                      ? ImagesConstants.saudiArabiaFlag
                      : ImagesConstants.unitedStateFlag,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEndAnimatedContainer() {
    if (!_controller.isForwardOrCompleted && isExpand) {
      _onTap();
    } else {
      if (getIt.get<UserHelper>().getAppLanguage() != selectedLanguage.name) {
        _changeLanguage(selectedLanguage);
      }
    }
  }

  void _changeLanguage(LanguageType languageType) async {
    await BlocProvider.of<AppThemeAndLanguagesCubit>(context)
        .changeLanguage(languageType: languageType)
        .then((value) {
      if (mounted) {
        languageType == LanguageType.arabic
            ? context.setLocale(const Locale('ar', 'SA'))
            : context.setLocale(const Locale('en', 'US'));
      }
    });
  }

  void _onOpenOrCloseContainer() {
    _controller.isForwardOrCompleted
        ? _controller.reverse().whenComplete(() => _changeSizeContainer())
        : _changeSizeContainer();
  }

  void _changeSizeContainer() {
    setState(() {
      width = isExpand ? 45.w : 100.w;
      isExpand = !isExpand;
    });
  }
}
