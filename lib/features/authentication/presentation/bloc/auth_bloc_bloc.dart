import 'package:bloc/bloc.dart';
import 'package:instagram_posts/core/utils/custom_loaders.dart';
import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';
import 'package:instagram_posts/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:meta/meta.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final AuthenticationUsecase _authenticationUsecase;

  AuthBlocBloc({required AuthenticationUsecase authenticationUsecase})
    : _authenticationUsecase = authenticationUsecase,
      super(AuthBlocInitial()) {
    on<AuthGetCurrentUserEvent>(_getCurrentUser);
    on<AuthRegisterUserEvent>(_registerUser);
    on<AuthSignInEvent>(_signInEvent);
    on<AuthSignOutEvent>(_signOutEvent);
  }

  Future<void> _getCurrentUser(
    AuthGetCurrentUserEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    CustomLoaders.showLoading();
    try {
      var user = await _authenticationUsecase.getCurrentUser();
      emit(AuthGetCurrentUserSuccessState(entity: user));
      CustomLoaders.hideLoading();
    } catch (e) {
      emit(
        AuthErrorState(
          message: "Cannot get the current user details: ${e.toString()}",
        ),
      );
      CustomLoaders.hideLoading();
    }
  }

  Future<void> _registerUser(
    AuthRegisterUserEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    CustomLoaders.showLoading();
    try {
      await _authenticationUsecase.registerUser(event.entity, event.password);
      emit(AuthRegisterUserSuccessState());
      CustomLoaders.hideLoading();
    } catch (e) {
      emit(
        AuthErrorState(message: "Cannot register user error: ${e.toString()}"),
      );
      CustomLoaders.hideLoading();
    }
  }

  Future<void> _signInEvent(
    AuthSignInEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    CustomLoaders.showLoading();
    try {
      var user = await _authenticationUsecase.signIn(
        event.email,
        event.password,
      );
      emit(AuthSignInSuccessState(entity: user));
      CustomLoaders.hideLoading();
    } catch (e) {
      emit(AuthErrorState(message: "Cannot use signin: ${e.toString()}"));
      CustomLoaders.hideLoading();
    }
  }

  Future<void> _signOutEvent(
    AuthSignOutEvent event,
    Emitter<AuthBlocState> emit,
  ) async {
    CustomLoaders.showLoading();
    try {
      await _authenticationUsecase.signOut();
      emit(AuthSignOutSuccessState());
      CustomLoaders.hideLoading();
    } catch (e) {
      emit(AuthErrorState(message: "Cannot use signout: ${e.toString()}"));
      CustomLoaders.hideLoading();
    }
  }
}
