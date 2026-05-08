part of 'auth_bloc_bloc.dart';

@immutable
sealed class AuthBlocState {}

final class AuthBlocInitial extends AuthBlocState {}

class AuthRegisterUserSuccessState extends AuthBlocState {}

class AuthGetCurrentUserSuccessState extends AuthBlocState {
  final UserEntity? entity;
  AuthGetCurrentUserSuccessState({required this.entity});
}

class AuthSignInSuccessState extends AuthBlocState {
  final UserEntity? entity;
  AuthSignInSuccessState({required this.entity});
}

class AuthSignOutSuccessState extends AuthBlocState {}

class AuthLoadingState extends AuthBlocState {}

class AuthErrorState extends AuthBlocState {
  final String message;
  AuthErrorState({required this.message});
}
