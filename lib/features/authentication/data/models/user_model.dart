import 'package:instagram_posts/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.profileImage,
    required super.isPrivate,
  });

  factory UserModel.fromJson(Map<String, dynamic>? map) {
    return UserModel(
      uid: map?['uid'] ?? '',
      name: map?['name'] ?? '',
      email: map?['email'] ?? '',
      profileImage: map?['profileImage'] ?? '',
      isPrivate: map?['isPrivate'] ?? false,
    );
  }

  factory UserModel.fromFirestore(dynamic map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "profileImage": profileImage,
      "isPrivate": isPrivate,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
    bool? isPrivate,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
