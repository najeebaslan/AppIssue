part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignInLoading extends AuthState {}

final class SignInSuccess extends AuthState {}

final class SignInError extends AuthState {
  final String error;
  SignInError(this.error);
}

// SignUp
final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {}

final class SignUpError extends AuthState {
  final String error;
  SignUpError(this.error);
}

// ResetPassword
final class ResetPasswordLoading extends AuthState {}

final class ResetPasswordSuccess extends AuthState {}

final class ResetPasswordError extends AuthState {
  final String error;
  ResetPasswordError(this.error);
}

// SignOut
final class LoadingSignOutState extends AuthState {}

final class SuccessSignOutState extends AuthState {}

final class ErrorSignOutState extends AuthState {
  final String error;

  ErrorSignOutState(this.error);
}

// Register With Google
final class RegisterWithGoogleLoading extends AuthState {}

final class RegisterWithGoogleSuccess extends AuthState {}

final class RegisterWithGoogleError extends AuthState {
  final String error;
  RegisterWithGoogleError(this.error);
}
