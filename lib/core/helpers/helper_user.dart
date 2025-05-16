import 'package:local_auth/local_auth.dart';

import '../../features/backup/backup_cubit/backup_cubit.dart';
import '../../features/settings/widgets/notification_cleanup.dart';
import '../constants/default_settings.dart';
import '../utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';
import 'shared_prefs_service.dart';

abstract class BaseHelperUser {
  void saveUserLoggedIn(bool isLoggedIn);
  bool isUserLoggedIn();
  Future<void> removeUserLoggedIn();

  bool isSeenOnboarding();
  Future seenOnboarding(bool isSeen);

  Future saveEnableLocalAuth(bool isEnable);
  bool isEnableLocalAuth();

  Future saveAppTheme(ThemeType themeType);
  String getAppTheme();

  Future saveAppLanguage(LanguageType languageType);
  String getAppLanguage();

  Future saveAppBiometric(BiometricType biometricType);
  String getAppBiometric();

  Future saveUsername(String username);
  String getUsername();

  Future saveImageUri(String imageUri);
  String getImageUri();

  Future saveEmail(String email);
  String getEmail();

  Future saveBackupStatus(BackupSyncTypes typeSync);
  BackupSyncTypes getBackupStatus();

  Future saveIsUserSyncAccount(bool isUserSyncAccount);
  bool getIsUserSyncAccount();

  Future saveLastUploadBackupDate(String date);
  String getLastUploadBackupDate();

  Future changeNotificationState(bool state);
  bool getNotificationState();

  Future saveNotificationCleanupOptions(NotificationCleanupOptions options);
  NotificationCleanupOptions getNotificationCleanupOptions();

  Future saveBackupOptions(BackupOptions options);
  BackupOptions getBackupOptions();

  Future saveIsUserInTrialMode(bool isUserSignInFirstTime);
  bool isUserInTrialMode();
}

class UserHelper implements BaseHelperUser {
  static const String _keyIsUserLoggedIn = 'IS_USER_LOGGED_IN';
  static const _keyOnBoarding = 'SEEN_ONBOARDING';
  static const _keyLocalAuth = 'LOCAL_AUTH';
  static const _keyAppTheme = 'APP_THEME';
  static const _keyAppLanguage = 'APP_LANGUAGE';
  static const _keyAppBiometric = 'APP_BIOMETRIC';
  static const _keyAppUsername = 'Username';
  static const _keyAppImageUri = 'APP_IMAGE_URI';
  static const _keyAppEmail = 'APP_EMAIL';
  static const _keyAppIsUserSyncAccount = 'APP_IS_USER_SYNC_ACCOUNT';
  static const _keyAppBackupSync = 'APP_BACKUP_SYNC';
  static const _keyAppLastUploadBackupDate = 'APP_LAST_UPLOAD_BACKUP_DATE';
  static const _keyAppNotification = 'APP_NOTIFICATION';
  static const _keyAppNotificationCleanup = 'APP_NOTIFICATION_CLEANUP';
  static const _keyAppBackupOptions = 'APP_BACKUP_OPTIONS';
  static const _keyAppIsUserInTrialMode = 'APP_IS_USER_IN_TRIAL_MODE';

  @override
  bool isUserLoggedIn() {
    return HelperSharedPreferences.getBool(_keyIsUserLoggedIn);
  }

  @override
  void saveUserLoggedIn(bool isLoggedIn) async {
    await HelperSharedPreferences.putBool(_keyIsUserLoggedIn, isLoggedIn);
  }

  @override
  bool isSeenOnboarding() {
    return HelperSharedPreferences.getBool(_keyOnBoarding);
  }

  @override
  Future seenOnboarding(bool isSeen) async {
    HelperSharedPreferences.putBool(_keyOnBoarding, isSeen);
  }

  @override
  bool isEnableLocalAuth() {
    return HelperSharedPreferences.getBool(_keyLocalAuth);
  }

  @override
  Future saveEnableLocalAuth(bool isEnable) async {
    await HelperSharedPreferences.putBool(_keyLocalAuth, isEnable);
  }

  @override
  String getAppTheme() {
    return HelperSharedPreferences.getString(
      _keyAppTheme,
      defValue: DefaultSettings.theme,
    );
  }

  @override
  Future<void> removeUserLoggedIn() async {
    await HelperSharedPreferences.remove(_keyIsUserLoggedIn);
  }

  @override
  Future saveAppTheme(ThemeType themeType) async {
    await HelperSharedPreferences.putString(_keyAppTheme, themeType.name);
  }

  @override
  String getAppLanguage() {
    return HelperSharedPreferences.getString(
      _keyAppLanguage,
      defValue: DefaultSettings.languageCode.languageCode,
    );
  }

  @override
  Future saveAppLanguage(LanguageType languageType) async {
    await HelperSharedPreferences.putString(_keyAppLanguage, languageType.name);
  }

  @override
  String getAppBiometric() {
    return HelperSharedPreferences.getString(
      _keyAppBiometric,
      defValue: DefaultSettings.biometric,
    );
  }

  @override
  Future saveAppBiometric(BiometricType biometricType) async {
    await HelperSharedPreferences.putString(_keyAppBiometric, biometricType.name);
  }

  @override
  String getImageUri() {
    return HelperSharedPreferences.getString(_keyAppImageUri);
  }

  @override
  String getUsername() {
    return HelperSharedPreferences.getString(_keyAppUsername, defValue: '');
  }

  @override
  Future saveImageUri(String imageUri) async {
    await HelperSharedPreferences.putString(_keyAppImageUri, imageUri);
  }

  @override
  Future saveUsername(String username) async {
    await HelperSharedPreferences.putString(_keyAppUsername, username);
  }

  @override
  String getEmail() {
    return HelperSharedPreferences.getString(_keyAppEmail);
  }

  @override
  Future saveEmail(String email) async {
    await HelperSharedPreferences.putString(_keyAppEmail, email);
  }

  @override
  BackupSyncTypes getBackupStatus() {
    final result = HelperSharedPreferences.getString(
      _keyAppBackupSync,
      defValue: DefaultSettings.backupSync.name,
    );

    return BackupSyncTypes.values.byName(result);
  }

  @override
  Future saveBackupStatus(BackupSyncTypes typeSync) async {
    await HelperSharedPreferences.putString(_keyAppBackupSync, typeSync.name);
  }

  @override
  bool getIsUserSyncAccount() {
    return HelperSharedPreferences.getBool(_keyAppIsUserSyncAccount, defValue: false);
  }

  @override
  Future saveIsUserSyncAccount(bool isUserSyncAccount) async {
    await HelperSharedPreferences.putBool(_keyAppIsUserSyncAccount, isUserSyncAccount);
  }

  @override
  String getLastUploadBackupDate() {
    return HelperSharedPreferences.getString(_keyAppLastUploadBackupDate, defValue: '');
  }

  @override
  Future saveLastUploadBackupDate(String date) async {
    await HelperSharedPreferences.putString(_keyAppLastUploadBackupDate, date);
  }

  @override
  Future changeNotificationState(bool state) async {
    await HelperSharedPreferences.putBool(_keyAppNotification, state);
  }

  @override
  bool getNotificationState() {
    return HelperSharedPreferences.getBool(
      _keyAppNotification,
      defValue: DefaultSettings.notificationState,
    );
  }

  @override
  NotificationCleanupOptions getNotificationCleanupOptions() {
    final type = HelperSharedPreferences.getString(
      _keyAppNotificationCleanup,
      defValue: DefaultSettings.notificationCleanupOptions.name,
    );

    return NotificationCleanupOptions.values.byName(type);
  }

  @override
  Future saveNotificationCleanupOptions(NotificationCleanupOptions options) async {
    await HelperSharedPreferences.putString(_keyAppNotificationCleanup, options.name);
  }

  @override
  BackupOptions getBackupOptions() {
    final type = HelperSharedPreferences.getString(
      _keyAppBackupOptions,
      defValue: DefaultSettings.backupOptions.name,
    );

    return BackupOptions.values.byName(type);
  }

  @override
  Future saveBackupOptions(BackupOptions options) async {
    await HelperSharedPreferences.putString(_keyAppBackupOptions, options.name);
  }

  @override
  bool isUserInTrialMode() {
    return HelperSharedPreferences.getBool(
      _keyAppIsUserInTrialMode,
      defValue: DefaultSettings.isUserInTrialMode,
    );
  }

  @override
  Future saveIsUserInTrialMode(bool isUserInTrialMode) async {
    await HelperSharedPreferences.putBool(_keyAppIsUserInTrialMode, isUserInTrialMode);
  }
}
