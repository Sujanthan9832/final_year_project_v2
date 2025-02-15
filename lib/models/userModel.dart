class UserModel {
  final String name;
  final String email;
  final String profileImage;

  UserModel({
    required this.name,
    required this.email,
    required this.profileImage,
  });

  // Factory method to create a dummy user
  factory UserModel.dummy() {
    return UserModel(
      name: "John Doe",
      email: "johndoe@example.com",
      profileImage: "assets/images/profile_pic.png", // Ensure this asset exists
    );
  }

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? "Unknown",
      email: json['email'] ?? "No Email",
      profileImage: json['profileImage'] ?? "assets/images/default_profile.png",
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}
