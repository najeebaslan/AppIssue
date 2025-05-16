import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';

import '../../../core/networking/network_info.dart';
import '../../../core/networking/type_response.dart';
import '../../../data/data_base/db_helper.dart';
import '../../../data/repositories/google_drive_repository.dart';
import '../backup_cubit/backup_cubit.dart';

class AutomaticUploadBackup {
  final BaseGoogleDriveRepository googleDriveRepository;
  final NetworkInfo networkInfo;
  final UserHelper userHelper;
  final DBHelper dbHelper;
  AutomaticUploadBackup({
    required this.googleDriveRepository,
    required this.networkInfo,
    required this.userHelper,
    required this.dbHelper,
  });
  Future<void> generateBackup() async {
    if (await _shouldUploadBackup()) {
      final backup = await dbHelper.generateBackup();
      if (backup is Failure) return;
      final googleDriveApiV3 = await googleDriveRepository.getDriveApi();
      if (googleDriveApiV3.success == null) return;
      final response = await googleDriveRepository.uploadBackup(
        driveApiV3: googleDriveApiV3.success!,
        backup: backup.success!,
      );
      if (response is Success) {
        userHelper.saveLastUploadBackupDate(
          DateTime.now().toIso8601String(),
        );
      }
    }
  }

  Future<bool> _shouldUploadBackup() async {
    // Retrieve backup status and options
    final statusUploadBackup = userHelper.getBackupStatus();
    final lastUploadBackupDate = userHelper.getLastUploadBackupDate();
    final getBackupFrequencyOption = userHelper.getBackupOptions();

    // If there's no last upload date, we should upload
    if (lastUploadBackupDate.isEmptyOrNull) return true;

    // Calculate the difference in days since the last upload
    final differenceDays = DateTime.now().difference(DateTime.parse(lastUploadBackupDate)).inDays;

    // Check if auto upload is enabled and internet is available
    final isAutoUploadEnabled =
        statusUploadBackup == BackupSyncTypes.auto && await networkInfo.isConnected;
    // Check if user in trial mode
    final isUserInTrialMode = userHelper.isUserInTrialMode();

    // Determine if a backup should be uploaded based on frequency
    if (!isAutoUploadEnabled || isUserInTrialMode) return false;

    switch (getBackupFrequencyOption) {
      case BackupOptions.daily:
        return differenceDays >= 1;
      case BackupOptions.weekly:
        return differenceDays >= 7;
      case BackupOptions.monthly:
        return differenceDays >= 30;
    }
  }
}
