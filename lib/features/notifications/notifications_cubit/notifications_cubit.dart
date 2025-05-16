import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';

import '../../../data/data_base/db_helper.dart';
import '../../../data/models/notification_model.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._dbHelper, this._userHelper) : super(NotificationsInitial());
  final DBHelper _dbHelper;
  final UserHelper _userHelper;

  void getNotifications() async {
    try {
      emit(LoadingGetNotifications());
      List<NotificationAdapter> notificationAdapter = [];

      final notifications = await _dbHelper.getAllNotifications();
      if (notifications.isEmptyOrNull) {
        emit(SuccessGetNotifications([]));
      } else {
        for (var notificationModel in notifications) {
          final getAccuse = await _dbHelper.getAccuseById(
            notificationModel.userID,
          );
          notificationAdapter.add(
            NotificationAdapter(
              notificationModel: notificationModel,
              accusedModel: getAccuse,
            ),
          );
        }
        emit(SuccessGetNotifications(notificationAdapter));
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ErrorGetNotifications(e.toString()));
    }
  }

  void clearAllNotifications() async {
    try {
      emit(LoadingDeleteNotifications());
      final updateAccused = await _dbHelper.clearAllNotifications(
        _userHelper.getNotificationCleanupOptions(),
      );
      if (updateAccused is int) {
        emit(SuccessDeleteNotifications());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(ErrorDeleteNotifications(e.toString()));
    }
  }
}
