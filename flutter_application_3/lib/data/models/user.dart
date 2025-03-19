class User {
  final String profileImage;
  final String email;
  final String userUid;
  final String typeUser;
  final String username;
  final DateTime createdAt;

  User({
    required this.profileImage,
    required this.email,
    required this.userUid,
    required this.typeUser,
    required this.username,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profileImage: json['profile_image'] ?? '',
      email: json['email'] ?? '',
      userUid: json['user_uid'] ?? '',
      typeUser: json['type_user'] ?? '',
      username: json['username'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_image': profileImage,
      'email': email,
      'user_uid': userUid,
      'type_user': typeUser,
      'username': username,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
