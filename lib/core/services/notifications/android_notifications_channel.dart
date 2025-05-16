import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../theme/app_colors.dart';

class AndroidNotificationsChannel {
  static const String channelId = 'najeeb.aslan.issue';
  static const String channelName = 'issue';
  static const String channelDescription = 'Issue Notifications';

  static Future<void> setupAndroidChannel(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String nameSoundNotificationFile) async {
    if (!kIsWeb) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              channelId,
              channelName,
              description: channelDescription,
              importance: Importance.high,
              playSound: true,
              ledColor: AppColors.kPrimaryColor,
              enableLights: false,
              audioAttributesUsage: AudioAttributesUsage.alarm,
              vibrationPattern: null,
              sound: RawResourceAndroidNotificationSound(nameSoundNotificationFile),
              showBadge: true,
            ),
          );
    }
  }
}
