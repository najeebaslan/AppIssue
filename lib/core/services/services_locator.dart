import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:issue/features/auth/auth_cubit/auth_cubit.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/data_base/db_helper.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/google_drive_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../features/accused/accused_cubit/accused_cubit.dart';
import '../../features/backup/backup_cubit/backup_cubit.dart';
import '../../features/backup/logic/auto_upload_backup.dart';
import '../../features/filter/filter_cubit/filter_cubit.dart';
import '../../features/notifications/notifications_cubit/notifications_cubit.dart';
import '../../features/settings/profile_cubit/profile_cubit.dart';
import '../helpers/helper_user.dart';
import '../helpers/task_scheduler.dart';
import '../networking/network_info.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {
  ///* ------------------------------ Cubits --------------------------*//

  getIt.registerFactory(() => AccusedCubit(getIt<DBHelper>()));

  getIt.registerFactory(
    () => AuthCubit(
      userHelper: getIt<UserHelper>(),
      authRepository: getIt<AuthRepositoryImpl>(),
    ),
  );

  getIt.registerFactory(
    () => ProfileCubit(
      profileRepository: getIt<ProfileRepositoryImpl>(),
      firebaseFireStore: getIt<FirebaseFirestore>(),
      userHelper: getIt<UserHelper>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerFactory(() => FilterCubit(getIt<DBHelper>()));

  getIt.registerFactory(
    () => NotificationsCubit(
      getIt<DBHelper>(),
      getIt<UserHelper>(),
    ),
  );

  getIt.registerFactory(
    () => BackupCubit(
      getIt<GoogleDriveRepositoryImpl>(),
      getIt<DBHelper>(),
      getIt<UserHelper>(),
    ),
  );

  ///* ------------------------------ Repository --------------------------*//
  getIt.registerLazySingleton(
    () => ProfileRepositoryImpl(
      networkInfo: getIt<NetworkInfo>(),
      firebaseStorage: getIt<FirebaseStorage>(),
      firebaseFireStore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton(
    () => AuthRepositoryImpl(
      networkInfo: getIt<NetworkInfo>(),
      firebaseAuth: getIt<FirebaseAuth>(),
      firebaseFireStore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GoogleDriveRepositoryImpl(
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  ///* ------------------------------ External --------------------------*//
  getIt.registerFactory(
    () => HelperTaskManager(
      userHelper: getIt.get<UserHelper>(),
      dbHelper: getIt.get<DBHelper>(),
      taskScheduler: getIt.get<TaskScheduler>(),
      notificationManager: getIt.get<NotificationManager>(),
      alarmProcessor: getIt.get<AlarmProcessor>(),
      automaticUploadBackup: getIt.get<AutomaticUploadBackup>(),
    ),
  );

  getIt.registerLazySingleton(() => InternetConnectionChecker());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseStorage.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => NotificationManager(getIt.get<DBHelper>()));
  getIt.registerLazySingleton(
    () => AlarmProcessor(getIt.get<NotificationManager>(), getIt.get<DBHelper>()),
  );

  getIt.registerLazySingleton(
    () => AutomaticUploadBackup(
      dbHelper: getIt.get<DBHelper>(),
      googleDriveRepository: getIt<GoogleDriveRepositoryImpl>(),
      networkInfo: getIt<NetworkInfo>(),
      userHelper: getIt.get<UserHelper>(),
    ),
  );

  getIt.registerLazySingleton(() => TaskScheduler());
  getIt.registerLazySingleton(() => UserHelper());
  getIt.registerLazySingleton(() => DBHelper.instance);
  getIt.registerLazySingleton(() => LocalAuthentication());
}
