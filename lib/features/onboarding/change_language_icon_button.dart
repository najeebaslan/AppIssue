import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/app_colors.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';

class ChangeLanguageIconButton extends StatelessWidget {
  const ChangeLanguageIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.padding.top + defaultPadding.h,
        left: defaultPadding.w * 1.5,
        right: defaultPadding.w,
      ),
      child: InkWell(
        onTap: () => showDialog(context),
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        borderRadius: BorderRadius.circular(30.r),
        child: SizedBox(
          width: 45.w,
          height: 45.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),
                child: Image.asset(
                  ImagesConstants.arabicLanguage,
                  width: 40.w,
                  height: 40.w,
                  color: context.themeData.primaryColor,
                ),
              ),
              Positioned(
                top: -5.h,
                left: -20.w,
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: defaultIconSize.w,
                  color: context.themeData.primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ),
          child: Dialog(
            surfaceTintColor: Colors.white.withValues(alpha: 0.2),
            insetPadding: EdgeInsets.zero,
            alignment: Alignment.center,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: context.themeData.cardColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              height: 150.h,
              width: context.width * 0.9,
              child: _dialogBodyContent(context),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Animation<double> customAnima = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.8),
            end: const Offset(0, 0.4),
          ).animate(customAnima),
          child: child,
        );
      },
    );
  }

  Column _dialogBodyContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -4, horizontal: 4),
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                AppIcons.close,
                color: AppColors.iconColor,
                size: defaultIconSize.w - 3,
              ),
            ),
            const Spacer(),
            Text(
              'chooseLanguage'.tr(),
              style: context.textTheme.titleLarge,
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _languageTypeWidget(
                context: context,
                flag: "🇸🇦",
                title: 'العربية',
                onSelect: () {
                  _changeLanguage(LanguageType.arabic, context);
                  Navigator.pop(context);
                },
              ),
              _languageTypeWidget(
                context: context,
                flag: "🇺🇸",
                title: 'English',
                onSelect: () {
                  _changeLanguage(LanguageType.english, context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  InkWell _languageTypeWidget({
    required BuildContext context,
    required String flag,
    required String title,
    required VoidCallback onSelect,
  }) {
    return InkWell(
      onTap: onSelect,
      child: Column(
        children: [
          Flexible(
            child: Text(
              flag,
              style: TextStyle(fontSize: 30.sp),
            ),
          ),
          Flexible(
            child: Text(
              title,
              style: context.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(LanguageType languageType, BuildContext context) async {
    await BlocProvider.of<AppThemeAndLanguagesCubit>(context)
        .changeLanguage(languageType: languageType)
        .then((value) {
      if (context.mounted) {
        languageType == LanguageType.arabic
            ? context.setLocale(const Locale('ar', 'SA'))
            : context.setLocale(const Locale('en', 'US'));
      }
    });
  }
}
