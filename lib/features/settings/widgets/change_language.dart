import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/theme.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';
import '../../../core/widgets/custom_button.dart';

class ChangeLanguageBottomSheet extends StatelessWidget {
  const ChangeLanguageBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    int initialLanguageIndex = context.locale.languageCode == 'ar' ? 0 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'whatLanguagePrefer'.tr(),
          style: context.textTheme.bodyMedium,
        ),
        SizedBox(height: defaultPadding.h),
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _buildLanguageTile(
                  context: context,
                  initialIndex: initialLanguageIndex,
                  flagUri: ImagesConstants.saudiArabiaFlag,
                  languageName: 'العربية',
                  languageType: LanguageType.arabic,
                  onChanged: (value) => setState(
                    () => initialLanguageIndex = value?.toInt() ?? 0,
                  ),
                ),
                SizedBox(height: defaultPadding.h),
                _buildLanguageTile(
                  context: context,
                  initialIndex: initialLanguageIndex,
                  flagUri: ImagesConstants.unitedStateFlag,
                  languageName: 'English',
                  languageType: LanguageType.english,
                  onChanged: (value) => setState(
                    () => initialLanguageIndex = value?.toInt() ?? 0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: defaultPadding.h * 3,
                    bottom: (context.mediaQuery.padding.bottom + 15).h,
                  ),
                  child: _buildContinueButton(context, initialLanguageIndex),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required int initialIndex,
    required String flagUri,
    required String languageName,
    required LanguageType languageType,
    void Function(int?)? onChanged,
  }) {
    return RadioListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 5,
      ),
      dense: true,
      splashRadius: defaultBorderRadius,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          width: 1,
          color: languageType.index != initialIndex
              ? context.customColors!.blackAndWhite!.withValues(alpha: 0.3)
              : context.themeData.primaryColor,
        ),
      ),
      selectedTileColor: context.themeData.primaryColor.withValues(alpha: .1),
      selected: languageType.index == initialIndex,
      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      secondary: _buildLanguageIndicator(
        flagUri: flagUri,
        isSelected: languageType.index == initialIndex,
      ),
      title: Text(languageName, style: context.textTheme.bodyLarge),
      activeColor: AppColors.kPrimaryColor,
      value: languageType.index,
      groupValue: initialIndex,
      onChanged: onChanged,
    );
  }

  Widget _buildLanguageIndicator({required String flagUri, required bool isSelected}) {
    return Container(
      height: 40.h,
      width: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isSelected ? AppColors.kPrimaryColor : AppColors.kPrimaryColor.withValues(alpha: 0.6),
      ),
      child: SvgPicture.asset(
        flagUri,
        height: 40.h,
        width: 40.w,
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, int initialIndex) {
    return CustomButton(
      onPressed: () async {
        await BlocProvider.of<AppThemeAndLanguagesCubit>(context).changeLanguage(
          languageType: LanguageType.values[initialIndex],
        );
        if (context.mounted) {
          LanguageType.values[initialIndex] == LanguageType.arabic
              ? context.setLocale(const Locale('ar', 'SA'))
              : context.setLocale(const Locale('en', 'US'));
          Navigator.pop(context);
        }
      },
      label: 'continue',
    );
  }
}
