import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';

import '../../constants/default_settings.dart';

part 'app_theme_and_languages_state.dart';

enum ThemeType { light, dark, system }

enum LanguageType { arabic, english }

class AppThemeAndLanguagesCubit extends Cubit<AppThemeAndLanguagesState> {
  AppThemeAndLanguagesCubit() : super(AppThemeInitial());

  String _userTheme = getIt.get<UserHelper>().getAppTheme();
  String get userTheme => _userTheme;

  String _userLanguage = getIt.get<UserHelper>().getAppLanguage();

  String get userLanguage => _userLanguage;

  set userTheme(String value) {
    _userTheme = value;
    emit(ChangeThemeState());
  }

  set userLanguage(String languageCode) {
    _userLanguage = languageCode;
    emit(ChangeLanguageState());
  }

  Locale get locale {
    switch (userLanguage) {
      case 'arabic':
        return const Locale('ar', 'SA');
      case 'english':
        return const Locale('en', 'US');
      default:
        return DefaultSettings.languageCode;
    }
  }

  ThemeMode get theme {
    switch (userTheme) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  void changeTheme(ThemeType themeType) async {
    await getIt.get<UserHelper>().saveAppTheme(themeType);
    userTheme = themeType.name;
  }

  Future<void> changeLanguage({required LanguageType languageType}) async {
    await getIt.get<UserHelper>().saveAppLanguage(languageType);
    userLanguage = languageType.name;
  }
}
