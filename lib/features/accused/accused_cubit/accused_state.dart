part of 'accused_cubit.dart';

sealed class AccusedState {}

final class AccusedInitial extends AccusedState {}

// Get Accused
final class LoadingGetAccused extends AccusedState {}

final class EmptyGetAccused extends AccusedState {}

final class SuccessGetAccused extends AccusedState {
  final List<AccusedModel> accused;
  SuccessGetAccused(this.accused);
}

final class ErrorGetAccused extends AccusedState {
  final String error;
  ErrorGetAccused(this.error);
}

// Add Accused
final class LoadingAddAccused extends AccusedState {}

final class SuccessAddAccused extends AccusedState {}

final class ErrorAddAccused extends AccusedState {
  final String error;
  ErrorAddAccused(this.error);
}

final class SetState extends AccusedState {
  final AccusedModel? accused;
  SetState({required this.accused});
}

// Get Notifications
final class LoadingGetNotifications extends AccusedState {}

final class EmptyGetNotifications extends AccusedState {}

final class SuccessGetNotifications extends AccusedState {
  final List<NotificationModel> notifications;
  SuccessGetNotifications(this.notifications);
}

final class ErrorGetNotifications extends AccusedState {
  final String error;
  ErrorGetNotifications(this.error);
}


final class OnRefreshProfileAppBar extends AccusedState {}
