part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}

final class AuthLogoutSuccess extends AuthState {}

final class AuthSendResetPasswordEmailSuccess extends AuthState {}

final class AuthPasswordRecovery extends AuthState {}

final class AuthUpdatePasswordSuccess extends AuthState {}