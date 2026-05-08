import 'package:instagram_posts/features/authentication/common/mappers.dart';
import 'package:instagram_posts/features/authentication/data/services/authentication_data_sources.dart';
import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';
import 'package:instagram_posts/features/authentication/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDataSources _services;

  AuthenticationRepositoryImpl({required AuthenticationDataSources services})
    : _services = services;

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _services.getCurrentUser();
  }

  @override
  Future<void> registerUser(UserEntity? user, String? password) async {
    final userModel = user?.toModel();
    await _services.registerUser(userModel, password);
  }

  @override
  Future<UserEntity> signIn(String? email, String? password) async {
    final model = await _services.signIn(email, password);
    return model.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _services.signOut();
  }
}
