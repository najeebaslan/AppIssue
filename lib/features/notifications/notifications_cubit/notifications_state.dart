part of 'notifications_cubit.dart';

sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

// Get Notifications
final class LoadingGetNotifications extends NotificationsState {}

final class SuccessGetNotifications extends NotificationsState {
  final List<NotificationAdapter> notificationAdapter;
  SuccessGetNotifications(this.notificationAdapter);
}

final class ErrorGetNotifications extends NotificationsState {
  final String error;
  ErrorGetNotifications(this.error);
}



// Delete Notifications
final class LoadingDeleteNotifications extends NotificationsState {}

final class SuccessDeleteNotifications extends NotificationsState {}

final class ErrorDeleteNotifications extends NotificationsState {
  final String error;
  ErrorDeleteNotifications(this.error);
}
