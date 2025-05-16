import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../app.dart';
import '../../router/routes_constants.dart';
import '../../theme/app_colors.dart';
import 'android_notifications_channel.dart';
import 'payload_model.dart';

class LocalNotificationService {
  static const androidSound = 'notification_sound';
  static const iosSound = 'notification_sound.wav';
  static const String openAction = 'openAction';
  static const String stopSoundAction = 'stopSoundAction';
  static const String iconLauncher = '@drawable/ic_launcher';
  static final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    // Initialize android channel

    await AndroidNotificationsChannel.setupAndroidChannel(
        _flutterLocalNotificationsPlugin, androidSound);

    final bool? grantedNotificationPermission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final bool? iosGrantedNotificationPermission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    if (grantedNotificationPermission == true || iosGrantedNotificationPermission == true) {
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings(iconLauncher);

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings(),
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        // On click notification when application is in background
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        // On click notification when application is in foreground
        onDidReceiveNotificationResponse: onClickNotification,
      );
    }
  }

  void onClickNotification(NotificationResponse response) {
    if (response.payload == null) return;
    navigatorKey.currentState!.pushNamed(
      AppRoutesConstants.showNotificationDetails,
      arguments: PayloadModel.fromJson(response.payload!),
    );
  }

  void showLocalNotification(NotificationParameters notificationParameters) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        AndroidNotificationsChannel.channelId, AndroidNotificationsChannel.channelName,
        color: AppColors.kPrimaryColor,
        priority: Priority.high,
        importance: Importance.max,
        playSound: true,
        ongoing: true,
        autoCancel: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
        icon: iconLauncher,
        channelDescription: AndroidNotificationsChannel.channelDescription,
        sound: const RawResourceAndroidNotificationSound(
          androidSound,
        ),
        actions: [
          const AndroidNotificationAction(
            openAction,
            'فتح',
            icon: DrawableResourceAndroidBitmap(iconLauncher),
            showsUserInterface: true,
          ),
          const AndroidNotificationAction(
            stopSoundAction,
            'إيقاف صوت الإنذار',
            cancelNotification: true,
            icon: DrawableResourceAndroidBitmap(iconLauncher),
          )
        ]);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
        sound: iosSound,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationParameters.id,
      notificationParameters.title,
      notificationParameters.body,
      platformChannelSpecifics,
      payload: PayloadModel(
        id: notificationParameters.id.toString(),
        title: notificationParameters.title,
        body: notificationParameters.body,
      ).toJson(),
    );
  }

  Future<bool> onLaunchNotification() async {
    // Set up callbacks to handle notification clicks when app is terminated or launched
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      navigatorKey.currentState!.pushNamed(
        AppRoutesConstants.showNotificationDetails,
        arguments: PayloadModel.fromJson(
          notificationAppLaunchDetails?.notificationResponse?.payload ?? '{}',
        ),
      );

      return true;
    } else {
      return false;
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload == null) return;
  navigatorKey.currentState?.pushNamed(
    AppRoutesConstants.showNotificationDetails,
    arguments: PayloadModel.fromJson(notificationResponse.payload!),
  );
}

class NotificationParameters {
  final int id;
  final String title;
  final String body;

  NotificationParameters({
    required this.title,
    required this.id,
    required this.body,
  });
}
