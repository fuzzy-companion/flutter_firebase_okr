import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> signIn(String? email, String? password);
  Future<void> registerUser(UserEntity? user, String? password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
