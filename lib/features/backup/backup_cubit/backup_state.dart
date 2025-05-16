part of 'backup_cubit.dart';

sealed class BackupState {}

final class BackupInitial extends BackupState {}

// Get All Backups
final class LoadingGetBackups extends BackupState {}

final class LoadedGetBackups extends BackupState {
  final List<api_v2.File> backups;

  LoadedGetBackups({required this.backups});
}

final class ErrorGetBackups extends BackupState {
  final String error;

  ErrorGetBackups(this.error);
}

// Download Backup
final class LoadingDownloadBackup extends BackupState {}

final class LoadedDownloadBackup extends BackupState {
  final List<int> dataStore;

  LoadedDownloadBackup({required this.dataStore});
}

final class ErrorDownloadBackup extends BackupState {
  final String error;

  ErrorDownloadBackup(this.error);
}

// Upload Backup
final class LoadingUploadBackup extends BackupState {}

final class LoadedUploadBackup extends BackupState {}

final class ErrorUploadBackup extends BackupState {
  final String error;

  ErrorUploadBackup(this.error);
}

// Delete Backup
final class LoadingDeleteBackup extends BackupState {}

final class DoneDeleteBackup extends BackupState {
  final List<api_v2.File> backups;

  DoneDeleteBackup({required this.backups});
}

final class ErrorDeleteBackup extends BackupState {
  final String error;

  ErrorDeleteBackup(this.error);
}

// Get Google Drive Api
final class LoadingGetGoogleDriveApi extends BackupState {}

final class LoadedGetGoogleDriveApi extends BackupState {}

final class ErrorGetGoogleDriveApi extends BackupState {
  final String error;

  ErrorGetGoogleDriveApi(this.error);
}

/// Restore Backup
final class LoadingRestoredBackup extends BackupState {}

final class DoneRestoredBackup extends BackupState {}

final class ErrorRestoredBackup extends BackupState {
  final String error;

  ErrorRestoredBackup(this.error);
}
