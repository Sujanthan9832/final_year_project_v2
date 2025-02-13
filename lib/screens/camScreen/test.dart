import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EmotionDetectionApp extends StatefulWidget {
  @override
  _EmotionDetectionAppState createState() => _EmotionDetectionAppState();
}

class _EmotionDetectionAppState extends State<EmotionDetectionApp> {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  int _k = 0;
  bool _isProcessing = false;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTFLite();
    // _initializeNotifications();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    // Start capturing images every 10 seconds
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (!_isProcessing) {
        await _captureAndProcessImage();
      }
    });
  }

  Future<void> _initializeTFLite() async {
    _interpreter = await Interpreter.fromAsset('model.tflite');
  }

  // Future<void> _initializeNotifications() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  Future<void> _captureAndProcessImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      final File imageFile = File(image.path);
      final emotion = await _analyzeImage(imageFile);

      if (emotion == 'sad') {
        _k++;
      } else {
        _k = 0;
      }

      if (_k >= 3) {
        // _sendNotification();
        _k = 0; // Reset after sending notification
      }
    } catch (e) {
      print('Error capturing or processing image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<String> _analyzeImage(File image) async {
    // Preprocess the image (resize, normalize, etc.)
    final imageInput = _preprocessImage(image);

    // Run inference
    final output = List.filled(1, 0).reshape([1, 1]);
    _interpreter!.run(imageInput, output);

    // Assuming the model outputs a single label (e.g., 'sad', 'happy')
    final emotion = output[0][0] == 1 ? 'sad' : 'not sad';
    return emotion;
  }

  List<List<double>> _preprocessImage(File image) {
    // Implement image preprocessing (resize, normalize, etc.)
    // This depends on your model's input requirements
    // Example: Resize to 128x128 and normalize pixel values
    return List.generate(128, (i) => List.filled(128, 0.0));
  }

  // Future<void> _sendNotification() async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'emotion_detection_channel',
  //     'Emotion Detection',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Emotion Detected',
  //     'The user seems sad.',
  //     platformChannelSpecifics,
  //   );
  // }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Emotion Detection')),
      body: CameraPreview(_cameraController!),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EmotionDetectionApp(),
  ));
}
