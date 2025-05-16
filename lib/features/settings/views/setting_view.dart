import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/router/routes_constants.dart';
import 'package:issue/features/auth/auth_cubit/auth_cubit.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/helpers/helper_user.dart';
import '../../../core/services/launch_uri.dart';
import '../../../core/services/local_auth_service.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../core/widgets/base_bottom_sheet.dart';
import '../widgets/biometrics_auth.dart';
import '../widgets/change_language.dart';
import '../widgets/contact_us.dart';
import '../widgets/list_tile_setting.dart';
import '../widgets/logout_button.dart';
import '../widgets/notification_cleanup.dart';
import 'profile_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding.w,
            vertical: defaultPadding.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Profile(),
              SizedBox(height: 5.h),
              const _PreferencesSection(),
              SizedBox(height: defaultPadding.h),
              const _LanguageSection(),
              SizedBox(height: defaultPadding.h),
              const _BiometricsAuth(),
              SizedBox(height: defaultPadding.h),
              const _BackUpSetting(),
              SizedBox(height: defaultPadding.h),
              const NotificationCleanup(),
              SizedBox(height: defaultPadding.h),
              const _AboutApp(),
              SizedBox(height: defaultPadding.h),
              const _AppReviews(),
              SizedBox(height: defaultPadding.h),
              const ContactUs(),
              SizedBox(height: defaultPadding.h),
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: defaultPadding.h),
        AdaptiveThemeContainer(
          width: context.width,
          height: 60.h,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                context.isDark ? AppIcons.weatherMoon : AppIcons.weatherSunny,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  context.isDark ? 'darkMode'.tr() : 'lightMode'.tr(),
                  style: context.textTheme.bodyMedium,
                ),
              ),
              const Spacer(),
              _ThemeSwitch(),
            ],
          ),
        ),
        SizedBox(height: defaultPadding.h),
        _NotificationSwitch(),
      ],
    );
  }
}

class _ThemeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: context.isDark,
      activeTrackColor: context.themeData.primaryColor,
      onChanged: (newValue) {
        BlocProvider.of<AppThemeAndLanguagesCubit>(context).changeTheme(
          newValue ? ThemeType.dark : ThemeType.light,
        );
      },
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      final value = getIt.get<UserHelper>().getNotificationState();
      return AdaptiveThemeContainer(
        width: context.width,
        height: 60.h,
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              value == true ? AppIcons.notifications : AppIcons.notificationsOff,
              size: defaultIconSize,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text('notifications'.tr(), style: context.textTheme.bodyMedium),
            ),
            const Spacer(),
            CupertinoSwitch(
              value: value,
              activeTrackColor: context.themeData.primaryColor,
              onChanged: (newValue) => setState(() {
                getIt.get<UserHelper>().changeNotificationState(newValue);
              }),
            )
          ],
        ),
      );
    });
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context) {
    return ListTileSetting(
      onTap: () => BaseBottomSheet().show(
        useDraggable: false,
        headerTitle: 'chooseLanguage',
        child: (controller) => const ChangeLanguageBottomSheet(),
        context: context,
      ),
      icon: AppIcons.changeLanguage,
      title: 'language',
      status: context.locale.languageCode == 'ar' ? 'theArabic' : 'theEnglish',
    );
  }
}

class _BiometricsAuth extends StatefulWidget {
  const _BiometricsAuth();

  @override
  State<_BiometricsAuth> createState() => _BiometricsAuthState();
}

class _BiometricsAuthState extends State<_BiometricsAuth> {
  final notifierStateBiometrics = ValueNotifier(
    getIt.get<UserHelper>().isEnableLocalAuth(),
  );
  @override
  void dispose() {
    notifierStateBiometrics.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifierStateBiometrics,
      builder: (context, value, child) {
        return ListTileSetting(
          onTap: () async {
            final localAuthService = LocalAuthService(getIt.get<LocalAuthentication>());
            final biometricTypes = await localAuthService.getAvailableBiometrics();
            final isDeviceSupported = await localAuthService.isDeviceSupported();
            bool drapableButtonSheet = !isDeviceSupported || biometricTypes.isEmptyOrNull;
            if (context.mounted) {
              BaseBottomSheet().show(
                isScrollControlled: drapableButtonSheet,
                useDraggable: drapableButtonSheet,
                centerTitle: !notifierStateBiometrics.value,
                headerTitle: 'authBiometric',
                child: (controller) => BiometricsAuthBottomSheet(
                  notifierStateBiometrics: notifierStateBiometrics,
                ),
                context: context,
              );
            }
          },
          icon: AppIcons.fingerprint,
          title: 'authBiometric',
          status: value ? 'enabled' : 'disabled',
        );
      },
    );
  }
}

class _BackUpSetting extends StatelessWidget {
  const _BackUpSetting();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isEnableAutoBackup = getIt.get<UserHelper>().getBackupStatus();
        return ListTileSetting(
          onTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoutesConstants.backupsSettingsView,
            ).then((onValue) {
              if (getIt.get<UserHelper>().getBackupStatus() != isEnableAutoBackup) {
                setState(() {});
              }
            });
          },
          icon: AppIcons.cloudSync,
          title: 'backup',
          status: isEnableAutoBackup.name,
        );
      },
    );
  }
}

class _AboutApp extends StatelessWidget {
  const _AboutApp();

  @override
  Widget build(BuildContext context) {
    return ListTileSetting(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutesConstants.aboutApp,
      ),
      icon: AppIcons.info,
      title: 'aboutApp',
    );
  }
}

// TODO========> When click to contact use button go to Apple Store if the mobile is iphone else open Google Play Store
class _AppReviews extends StatelessWidget {
  const _AppReviews();

  @override
  Widget build(BuildContext context) {
    return ListTileSetting(
      onTap: () => LaunchUri().reviewApplication(),
      icon: AppIcons.star,
      title: 'appReview',
    );
  }
}
