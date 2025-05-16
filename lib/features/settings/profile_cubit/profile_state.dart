part of 'profile_cubit.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

// Get Profile States
class LoadingGetProfileState extends ProfileState {}

class SuccessGetProfileState extends ProfileState {
  const SuccessGetProfileState({required this.profileModel});
  final ProfileModel profileModel;
}

class ErrorGetProfileState extends ProfileState {
  const ErrorGetProfileState({required this.error});
  final String error;
}

// Update Profile States
class LoadingUpdateProfileState extends ProfileState {}

class SuccessUpdateProfileState extends ProfileState {}

class ErrorUpdateProfileState extends ProfileState {
  const ErrorUpdateProfileState({required this.error});

  final String error;
}

// Delete Account States
class LoadingDeleteAccountState extends ProfileState {}

class SuccessDeleteAccountState extends ProfileState {}

class ErrorDeleteAccountState extends ProfileState {
  const ErrorDeleteAccountState({required this.error});

  final String error;
}

// Update Image States
class LoadingUpdateImageState extends ProfileState {}

class SuccessUpdateImageState extends ProfileState {
  final String imageUri;

  SuccessUpdateImageState(this.imageUri);
}

class ErrorUpdateImageState extends ProfileState {
  const ErrorUpdateImageState({required this.error});

  final String error;
}

// Refresh Profile
class RefreshProfileState extends ProfileState {}
