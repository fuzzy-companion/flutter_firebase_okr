class UserEntity {
  final String? uid;
  final String? name;
  final String? email;
  final String? profileImage;
  final bool? isPrivate;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.isPrivate,
  });

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
    bool? isPrivate,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}
