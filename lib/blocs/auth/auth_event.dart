part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String mobile;
  final String password;

  LoginRequested({required this.mobile, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String mobile;
  final String password;
  final String confirmPassword;

  RegisterRequested({
    required this.name,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
  });
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}