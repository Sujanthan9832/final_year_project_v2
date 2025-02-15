import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stress_management_app/providers/customProvider.dart';
import 'package:stress_management_app/providers/locator.dart';
import 'package:stress_management_app/screens/EmotionDetectionService/emotion_detection_view_model.dart';
import 'package:stress_management_app/screens/home/home.dart';
import 'package:stress_management_app/services/localNotification.dart';
import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  setup();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CustomProvider()),
  ], child: const MyApp()));
}

/// Background task handler
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final viewModel = EmotionDetectionViewModel();
    await viewModel.initializeWithoutUI(); // Background initialization
    await viewModel.captureAndAnalyze();
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomProvider>(
      builder: (context, customProvider, child) {
        return MaterialApp(
          title: 'Stress Management App',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: customProvider.themeData,
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(
          //       seedColor: const Color.fromARGB(255, 58, 183, 68)),
          //   useMaterial3: true,
          // ),
          home: const MyHomePage(title: 'Stress Management App'),
          builder: (context, child) {
            NotificationService().initialize(context); // Pass context
            return child!;
          },
        );
      },
    );
  }
}
