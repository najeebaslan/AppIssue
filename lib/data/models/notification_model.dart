import '../../core/utils/alarms_days.dart';
import 'accuse_model.dart';

class NotificationModel {
  final int? notificationID;
  final int userID;
  final String notificationDate;
  final AlarmTypes alarmType;

  NotificationModel({
    this.notificationID,
    required this.userID,
    required this.notificationDate,
    required this.alarmType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'notificationDate': notificationDate,
      'alarmType': alarmType.index,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationID: map['notificationID'],
      userID: map['userID'],
      notificationDate: map['notificationDate'],
      alarmType: AlarmTypes.values[map['alarmType']],
    );
  }
}

class NotificationAdapter {
  final NotificationModel notificationModel;
  final AccusedModel accusedModel;

  NotificationAdapter({
    required this.notificationModel,
    required this.accusedModel,
  });
}
