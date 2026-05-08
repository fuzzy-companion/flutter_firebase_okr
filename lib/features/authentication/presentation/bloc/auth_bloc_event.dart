part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocEvent {}

class AuthRegisterUserEvent extends AuthBlocEvent {
  final UserEntity? entity;
  final String password;

  AuthRegisterUserEvent({required this.entity, required this.password});
}

class AuthGetCurrentUserEvent extends AuthBlocEvent {}

class AuthSignInEvent extends AuthBlocEvent {
  final String email;
  final String password;

  AuthSignInEvent({required this.email, required this.password});
}

class AuthSignOutEvent extends AuthBlocEvent {}
