class UserModel {
  String name;
  String email;
  String bio;
  String profilePic;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.profilePic,
  });

  // from map
  factory UserModel.fromJSON(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toJSON() {
    return {
      "name": name,
      "email": email,
      "bio": bio,
      "profilePic": profilePic,
    };
  }
}
