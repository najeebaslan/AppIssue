import 'dart:io';

import 'package:intl/intl.dart' as intl;
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/services/services_locator.dart' as di;
import '../../data/data_base/db_helper.dart';
import '../../data/models/notification_model.dart';
import '../../features/backup/logic/auto_upload_backup.dart';
import '../services/notifications/local_notifications.dart';
import '../utils/alarms_days.dart';
import 'helper_user.dart';

class TaskScheduler {
  void scheduleEventThreeTimesPerDay(String userId) {
    if (Platform.isIOS) {
      _scheduleEventThreeTimesPerDayIOS(userId);
    } else {
      _scheduleEventThreeTimesPerDayAndroid(userId);
    }
  }

  /// ScheduleEvent method for run three times in day
  /// at 8:00 AM, 2:00 PM, and 8:00 PM of every days
  /// This work with [IOS]
  void _scheduleEventThreeTimesPerDayIOS(String userId) {
    const iOSBackgroundAppRefresh = "najeeb.aslan.issue";
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final taskIntervals = [
      const Duration(hours: 8), // First task at 8:00 AM
      const Duration(hours: 20), // Second task at 8:00 PM
    ];
    for (int i = 0; i < taskIntervals.length; i++) {
      final taskTime = startOfDay.add(taskIntervals[i]);
      Workmanager().registerPeriodicTask(
        "$iOSBackgroundAppRefresh$i", // A unique name for the task
        '${userId}Tag$i', // A unique tag for the task
        frequency: const Duration(days: 1), // Repeat the task every day
        initialDelay: taskTime.difference(now), // Delay before the first execution of the task
        existingWorkPolicy: ExistingWorkPolicy.keep,
        constraints: _getDefaultConstraints(),
      );
    }
  }

  /// ScheduleEvent method for run three times in day
  /// at 8:00 AM, 2:00 PM, and 8:00 PM of every days
  /// This work with [Android]
  void _scheduleEventThreeTimesPerDayAndroid(String userId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final taskIntervals = [
      const Duration(hours: 8), // First task at 8:00 AM
      const Duration(hours: 20), // Second task at 8:00 PM
    ];
    for (int i = 0; i < taskIntervals.length; i++) {
      final taskTime = startOfDay.add(taskIntervals[i]);
      Workmanager().registerPeriodicTask(
        '$userId$i', // A unique name for the task
        '${userId}Tag$i', // A unique tag for the task
        frequency: const Duration(days: 1), // Repeat the task every day
        initialDelay: taskTime.difference(now), // Delay before the first execution of the task
        existingWorkPolicy: ExistingWorkPolicy.keep,
        constraints: _getDefaultConstraints(),
      );
    }
  }

  Constraints _getDefaultConstraints() {
    return Constraints(
      requiresCharging: false,
      requiresDeviceIdle: false,
      requiresBatteryNotLow: false,
      requiresStorageNotLow: false,
      networkType: NetworkType.not_required,
    );
  }

  /// Only used [testWorkManager] in the Debug Mode
  void testWorkManager() {
    const simpleTaskId = "najeeb.aslan.issue0";
    Workmanager().registerPeriodicTask(
      simpleTaskId,
      simpleTaskId,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 1),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: _getDefaultConstraints(),
    );
  }
}

class NotificationManager {
  final DBHelper dbHelper;

  NotificationManager(this.dbHelper);

  Future<void> showAndSaveNotification(AccusedModel accused, AlarmLevel level) async {
    showNotificationAlarm(accused, level);
    await saveNotification(
      NotificationModel(
        userID: accused.id ?? 0,
        notificationDate: DateTime.now().toString(),
        alarmType: getAlarmType(level),
      ),
    );
  }

  Future<void> saveNotification(NotificationModel notification) async {
    await dbHelper.addNotification(notification);
  }

  void showNotificationAlarm(AccusedModel accused, AlarmLevel alarmLevel) {
    bool isEnableNotifications = di.getIt.get<UserHelper>().getNotificationState();
    if (isEnableNotifications) {
      LocalNotificationService().showLocalNotification(NotificationParameters(
        id: accused.id ?? 0,
        title: accused.name ?? '',
        body: 'سينتهي التنبية ${getLevelName(alarmLevel)} '
            '${getDeferenceExpiredDate(DateTime.parse(accused.date.toString()), alarmLevel)} '
            'تمت إضافته في ${intl.DateFormat.yMd().format(DateTime.parse(accused.date.toString()))}',
      ));
    }
  }

  String getDeferenceExpiredDate(DateTime dateTime, AlarmLevel alarmLevel) {
    final difference = calculateRemainingDaysToThirdAlarm(dateTime, alarmLevel);
    return difference <= 0 ? 'اليوم' : 'بعد يوم واحد';
  }

  String getLevelName(AlarmLevel alarmLevel) {
    switch (alarmLevel) {
      case AlarmLevel.first:
        return 'الأول';
      case AlarmLevel.next:
        return 'الثاني';
      case AlarmLevel.third:
        return 'الثالث';
    }
  }

  int calculateRemainingDaysToThirdAlarm(DateTime dateTime, AlarmLevel alarmLevel) {
    final alarmDate = dateTime.add(Duration(days: AlarmsDays.calculateLavalDays(alarmLevel)));
    return DateTime.now().getRemainingDays(time: alarmDate);
  }

  AlarmTypes getAlarmType(AlarmLevel level) {
    switch (level) {
      case AlarmLevel.first:
        return AlarmTypes.firstAlarm;
      case AlarmLevel.next:
        return AlarmTypes.nextAlarm;
      case AlarmLevel.third:
        return AlarmTypes.thirdAlert;
    }
  }
}

class AlarmProcessor {
  final NotificationManager notificationManager;
  final DBHelper dbHelper;

  AlarmProcessor(this.notificationManager, this.dbHelper);

  Future<void> processAlarms() async {
    final alarms = [
      await dbHelper.fetchData7DaysAgo(),
      await dbHelper.fetchData52DaysAgo(),
      await dbHelper.fetchData97DaysAgo(),
    ];

    for (int i = 0; i < alarms.length; i++) {
      final alarmLevel = AlarmLevel.values[i];
      for (var alarm in alarms[i]) {
        await notificationManager.showAndSaveNotification(alarm, alarmLevel);
        await ifTheLevelAlarmDoneDisableIt(alarm.date, alarmLevel, alarm.id!);
      }
    }
  }

  Future<void> ifTheLevelAlarmDoneDisableIt(
      String? dateStr, AlarmLevel alarmLevel, int userID) async {
    if (dateStr == null) return;

    DateTime date = DateTime.parse(dateStr);
    int remainingDays = calculateRemainingDaysToThirdAlarm(date, alarmLevel);
    if (remainingDays == 0) {
      await dbHelper.updateByNameField(
        accusedID: userID,
        nameField: getAlarmType(alarmLevel).name,
        typeAlarm: 1,
      );
    }
  }

  AlarmTypes getAlarmType(AlarmLevel level) {
    switch (level) {
      case AlarmLevel.first:
        return AlarmTypes.firstAlarm;
      case AlarmLevel.next:
        return AlarmTypes.nextAlarm;
      case AlarmLevel.third:
        return AlarmTypes.thirdAlert;
    }
  }

  int calculateRemainingDaysToThirdAlarm(DateTime dateTime, AlarmLevel alarmLevel) {
    final alarmDate = dateTime.add(Duration(days: AlarmsDays.calculateLavalDays(alarmLevel)));
    return DateTime.now().getRemainingDays(time: alarmDate);
  }
}

class HelperTaskManager {
  final UserHelper userHelper;
  final DBHelper dbHelper;
  final TaskScheduler taskScheduler;
  final NotificationManager notificationManager;
  final AlarmProcessor alarmProcessor;
  final AutomaticUploadBackup automaticUploadBackup;

  HelperTaskManager({
    required this.userHelper,
    required this.dbHelper,
    required this.taskScheduler,
    required this.notificationManager,
    required this.alarmProcessor,
    required this.automaticUploadBackup,
  });

  void scheduleTasks(String userId) {
    taskScheduler.scheduleEventThreeTimesPerDay(userId);
  }

  void testScheduleTasks() {
    taskScheduler.testWorkManager();
  }

  Future<void> onExecuteTask() async {
    if (userHelper.isUserLoggedIn()) {
      await alarmProcessor.processAlarms();
      await clearAllNotifications();
      await automaticUploadBackup.generateBackup();
    }
  }

  Future<void> clearAllNotifications() async {
    await dbHelper.clearAllNotifications(userHelper.getNotificationCleanupOptions());
  }
}
