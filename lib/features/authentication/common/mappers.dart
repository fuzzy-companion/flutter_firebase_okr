import 'package:instagram_posts/features/authentication/data/models/user_model.dart';
import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      profileImage: profileImage,
      isPrivate: isPrivate,
    );
  }
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() {
    return UserModel(
      uid: uid,
      email: email,
      name: name,
      profileImage: profileImage,
      isPrivate: isPrivate,
    );
  }
}