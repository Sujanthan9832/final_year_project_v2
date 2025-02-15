import 'package:stress_management_app/models/userModel.dart';

class UserService {
  Future<UserModel> getUser() async {
    // Mocked user data (Replace with real API call or storage retrieval)
    return UserModel(
      name: "Sujanthan",
      email: "Sujanthan@example.com",
      profileImage: "assets/images/profile_pic.png",
    );
  }
}
