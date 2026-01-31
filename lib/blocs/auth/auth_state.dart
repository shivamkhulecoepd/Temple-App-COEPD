part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? errorMessage;

  const Unauthenticated({this.errorMessage});
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}