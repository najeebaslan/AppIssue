part of 'app_theme_and_languages_cubit.dart';

sealed class AppThemeAndLanguagesState {}

final class AppThemeInitial extends AppThemeAndLanguagesState {}

final class ChangeThemeState extends AppThemeAndLanguagesState {}

final class ChangeLanguageState extends AppThemeAndLanguagesState {}
