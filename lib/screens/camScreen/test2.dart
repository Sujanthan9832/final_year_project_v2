import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EmotionDetectionService {
  late CameraController _cameraController;
  late Interpreter _interpreter;
  int k = 0;
  // final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  EmotionDetectionService() {
    _init();
  }

  Future<void> _init() async {
    await _initCamera();
    await _loadModel();
    // _initNotifications();
    _startEmotionDetection();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras.first, ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/emotion_model.tflite');
  }

  // void _initNotifications() {
  //   const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final InitializationSettings initSettings = InitializationSettings(android: androidSettings);
  //   _notificationsPlugin.initialize(initSettings);
  // }

  Future<void> _startEmotionDetection() async {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      await _captureAndAnalyze();
    });
  }

  Future<void> _captureAndAnalyze() async {
    final XFile imageFile = await _cameraController.takePicture();
    final emotion = await _analyzeImage(File(imageFile.path));

    if (emotion == 'sad') {
      k++;
      if (k == 3) {
        // _sendNotification();
      }
    } else {
      k = 0;
    }
  }

  Future<String> _analyzeImage(File imageFile) async {
    // Process image and pass it through the TFLite model (Preprocessing needed)
    // Assuming model returns a string "happy", "sad", etc.
    return "sad"; // Placeholder: Replace with actual TFLite model prediction
  }

  // void _sendNotification() {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'emotion_alert',
  //     'Emotion Alerts',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails details = NotificationDetails(android: androidDetails);
  //   _notificationsPlugin.show(0, 'Alert', 'Detected sad emotions multiple times.', details);
  // }
}
