import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/firebase_options.dart';
import 'package:workmanager/workmanager.dart';

import '../core/services/services_locator.dart' as di;
import 'app.dart';
import 'core/helpers/shared_prefs_service.dart';
import 'core/helpers/task_scheduler.dart';
import 'core/services/notifications/local_notifications.dart';
import 'core/utils/bloc_observer.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: "issues",
  );

  await ScreenUtil.ensureScreenSize();
  await di.initServiceLocator();
  await HelperSharedPreferences.getInstance();
  await LocalNotificationService().init();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  FlutterNativeSplash.remove();

  runApp(
    EasyLocalization(
      saveLocale: true,
      fallbackLocale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      child: const Issue(),
    ),
  );
}

// Mandatory if the App is obfuscated or using Flutter 3.1+
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      try {
        await di.initServiceLocator();
        await HelperSharedPreferences.getInstance();
        await di.getIt.get<HelperTaskManager>().onExecuteTask();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    },
  );
}
