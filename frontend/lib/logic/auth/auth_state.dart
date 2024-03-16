part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AUthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class SignOutSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
