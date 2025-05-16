import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:upgrader/upgrader.dart';

import '../utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';

class CustomUpgradeAlert extends StatelessWidget {
  const CustomUpgradeAlert({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final locale = context.read<AppThemeAndLanguagesCubit>().locale;
    return UpgradeAlert(
      dialogStyle: context.isIOS ? UpgradeDialogStyle.cupertino : UpgradeDialogStyle.material,
      upgrader: Upgrader(
        languageCode: locale.languageCode,
        messages: UpgraderMessages(code: locale.languageCode),
        countryCode: locale.countryCode,
        // debugLogging: true,
        // debugDisplayAlways: true,
        //  durationUntilAlertAgain: const Duration(days: 1),// Enable it in debug mode
      ),
      child: child,
    );
  }
}
