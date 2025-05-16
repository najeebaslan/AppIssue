import 'dart:io' as io;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart' as api_v2;
import 'package:googleapis/drive/v3.dart' as api_v3;
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/networking/type_response.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/helpers/helper_user.dart';
import '../../../data/data_base/db_helper.dart';
import '../../../data/repositories/google_drive_repository.dart';

part 'backup_state.dart';

enum BackupSyncTypes { auto, manual }

enum BackupOptions { daily, weekly, monthly }

enum TypeRestoreBackup { merge, replace }

class BackupCubit extends Cubit<BackupState> {
  BackupCubit(this._googleDriveRepository, this._dbHelper, this._userHelper)
      : super(BackupInitial());
  final BaseGoogleDriveRepository _googleDriveRepository;
  final DBHelper _dbHelper;
  final UserHelper _userHelper;

  GoogleSignInAccount? _currentUser;
  api_v3.DriveApi? _driveApiV3;

  void getAllBackups() async {
    emit(LoadingGetBackups());
    final currentUser = await _googleDriveRepository.googleSignInSilently();
    if (currentUser.success == null) return;
    final backups = await _googleDriveRepository.getAllBackups(
      currentUser: currentUser.success!,
    );
    if (backups is Success) {
      if (!isClosed) {
        emit(LoadedGetBackups(backups: backups.success ?? []));
      }
    } else if (backups is Failure) {
      emit(ErrorGetBackups(backups.failure.validate()));
    }
  }

  Future<void> getDriveApi() async {
    emit(LoadingGetGoogleDriveApi());
    final connectToGoogleDrive = await _googleDriveRepository.getDriveApi();
    if (connectToGoogleDrive is Success) {
      _driveApiV3 = connectToGoogleDrive.success;
      emit(LoadedGetGoogleDriveApi());
    } else if (connectToGoogleDrive is Failure) {
      emit(ErrorGetGoogleDriveApi(connectToGoogleDrive.failure.toString()));
    }
  }

  void deleteBackup({required String backupID, required List<api_v2.File> listBackups}) async {
    emit(LoadingDeleteBackup());
    final api = await _googleDriveRepository.deleteBackup(_driveApiV3!, backupID);
    if (api is Success) {
      listBackups.removeWhere((files) => files.id == backupID);
      emit(DoneDeleteBackup(backups: listBackups));
    } else if (api is Failure) {
      emit(ErrorDeleteBackup(api.failure.validate()));
    }
  }

  void uploadBackup() async {
    try {
      emit(LoadingUploadBackup());

      if (_userHelper.isUserInTrialMode()) {
        emit(ErrorUploadBackup('notPossibleCreateBackupOfTrialData'.tr()));
        return;
      }

      if (_currentUser != null) {
        await reSignInWithGoogleAndreCallFunction(uploadBackup);
      } else {
        final backup = await _dbHelper.generateBackup();
        if (backup is Failure) {
          emit(ErrorUploadBackup('notFountDataInDataBase'.tr()));
          return;
        }
        final googleDriveApiV3 = await _googleDriveRepository.getDriveApi();
        if (googleDriveApiV3.success == null) {
          emit(ErrorUploadBackup(googleDriveApiV3.failure.toString()));
          return;
        }
        final upload = await _googleDriveRepository.uploadBackup(
          driveApiV3: googleDriveApiV3.success!,
          backup: backup.success!,
        );
        if (upload is Success) {
          emit(LoadedUploadBackup());
        } else if (upload is Failure) {
          emit(ErrorUploadBackup(upload.failure.validate()));
        }
      }
    } catch (e) {
      emit(ErrorUploadBackup(e.toString()));
    }
  }

  void downloadBackup({required String backupID}) async {
    emit(LoadingDownloadBackup());

    try {
      final backup = await _googleDriveRepository.downloadBackup(_driveApiV3!, backupID);

      if (backup is Success) {
        List<int> dataStore = [];

        backup.success?.listen(
          (data) => dataStore.addAll(data),
          cancelOnError: true,
          onError: (error) => emit(ErrorDownloadBackup('Stream error: $error')),
        );

        emit(LoadedDownloadBackup(dataStore: dataStore));
      } else if (backup is Failure) {
        emit(ErrorDownloadBackup(backup.failure.validate()));
      }
    } catch (e) {
      emit(ErrorDownloadBackup('Download failed: $e'));
    }
  }

  Future<void> restoreBackup({
    required List<int> dataStore,
    required TypeRestoreBackup typeResterBackup,
  }) async {
    final String path = (await getApplicationSupportDirectory()).path;
    final String backupFileName = '$path/IssueApp.txt';
    io.File file = io.File(backupFileName);
    try {
      emit(LoadingRestoredBackup());
      await file.writeAsBytes(dataStore);
      String fileContent = await file.readAsString();
      final response = await _dbHelper.restoreBackup(
        backup: fileContent,
        typeResterBackup: typeResterBackup,
      );

      if (response is Success) {
        emit(DoneRestoredBackup());
      } else if (response is Failure) {
        emit(ErrorRestoredBackup('Failed to restore backup'));
      }
    } on io.FileSystemException catch (_) {
      emit(ErrorRestoredBackup('Failed to restore backup'));
    } finally {
      // Delete the file after use
      await file.delete(recursive: true);
    }
  }

  Future<void> reSignInWithGoogleAndreCallFunction(void Function() function) async {
    try {
      final googleSignInSilently = await _googleDriveRepository.googleSignInSilently();
      if (googleSignInSilently is Success) {
        _currentUser = googleSignInSilently.success;
        function.call();
      }
    } catch (e) {
      emit(ErrorGetBackups(e.toString()));
    }
  }
}
