import 'package:stacked/stacked.dart';
import 'package:stress_management_app/providers/locator.dart';
import 'package:stress_management_app/services/userService.dart';
import 'package:stress_management_app/services/analyticsService.dart';
import 'package:stress_management_app/models/userModel.dart';

class MoreViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  String userName = "";
  String email = "";
  String profileImage = "";
  Map<String, double> emotionData = {};

  Future<void> loadUserData() async {
    setBusy(true);

    // Get Dummy User Data
    UserModel user = await _userService.getUser();
    userName = user.name;
    email = user.email;
    profileImage = user.profileImage;

    // Get Dummy Emotion Analytics
    emotionData = await _analyticsService.getEmotionStats();

    setBusy(false);
  }
}
