import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stress_management_app/screens/home/home.dart';
import 'package:stress_management_app/services/localNotification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress Management App',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 183, 68)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Stress Management App'),
      builder: (context, child) {
        NotificationService().initialize(context); // Pass context
        return child!;
      },
    );
  }
}
