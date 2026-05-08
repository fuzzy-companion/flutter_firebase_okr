import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_posts/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:instagram_posts/features/authentication/data/services/authentication_data_sources.dart';
import 'package:instagram_posts/features/authentication/domain/repository/authentication_repository.dart';
import 'package:instagram_posts/features/authentication/domain/usecases/authentication_usecase.dart';
import 'package:instagram_posts/features/authentication/presentation/bloc/auth_bloc_bloc.dart';

final getIt = GetIt.instance;
Future<void> initializeDependencies() async {
  await _configureApp();
  await _initAuthLayer();
}

// Configure app wide dependencies
Future<void> _configureApp() async {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
}

// Configure feature wise dependencies
Future<void> _initAuthLayer() async {
  // 🔹 Data Source
  getIt.registerLazySingleton<AuthenticationDataSources>(
    () => AuthenticationDataSources(
      auth: getIt<FirebaseAuth>(),
      firebaseFirestore: getIt<FirebaseFirestore>(),
    ),
  );

  // 🔹 Repository (bind abstraction → implementation)
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      services: getIt<AuthenticationDataSources>(),
    ),
  );

  // 🔹 Usecase
  getIt.registerFactory<AuthenticationUsecase>(
    () => AuthenticationUsecase(
      authenticationRepository: getIt<AuthenticationRepository>(),
    ),
  );

  // 👌Register bloc dependency for Auth
  getIt.registerFactory<AuthBlocBloc>(
    () => AuthBlocBloc(authenticationUsecase: getIt<AuthenticationUsecase>()),
  );
}
