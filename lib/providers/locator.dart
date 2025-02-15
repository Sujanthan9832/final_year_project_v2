import 'package:get_it/get_it.dart';
import 'package:stress_management_app/constants/colors.dart';
import 'package:stress_management_app/providers/customProvider.dart';
import 'package:stress_management_app/services/analyticsService.dart';
import 'package:stress_management_app/services/userService.dart';

GetIt locator = GetIt.instance;

final customerProvider = locator<CustomProvider>();
final colors = locator<StressManagmentAppColors>();

void setup() {
  locator.registerLazySingleton<CustomProvider>(
    () => CustomProvider(),
  );
  locator.registerLazySingleton<StressManagmentAppColors>(
    () => StressManagmentAppColors(),
  );
  locator.registerLazySingleton<UserService>(
    () => UserService(),
  );
  locator.registerLazySingleton<AnalyticsService>(
    () => AnalyticsService(),
  );
}
