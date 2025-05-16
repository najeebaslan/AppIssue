import 'package:flutter/material.dart';

import '../../features/backup/backup_cubit/backup_cubit.dart';
import '../../features/settings/widgets/notification_cleanup.dart';

class DefaultSettings {
  static const String theme = 'light';
  static const double fontSize = 16.0;
  static const String biometric = 'empty';
  static const bool notificationState = true;
  static const bool isUserInTrialMode = true;
  static const String fontType = 'IBM Plex Sans Arabic';
  static const Locale languageCode = Locale('ar', 'SA');
  static const String supportPhoneNumber = '+967773228315';
  static const String supportEmail = 'najeebaslan2019@gmail.com';
  static const String nameCollectionUsersInFirebase = 'users';
  static const BackupSyncTypes backupSync = BackupSyncTypes.auto;
  static const BackupOptions backupOptions = BackupOptions.weekly;
  static const notificationCleanupOptions = NotificationCleanupOptions.monthly;

  /// Please do not change this name, and if you change it,
  ///  the application will be able to obtain backup files from Google Drive
  static const String nameFolderBackupsInGoogleDrive = 'appDataFolder';
}
