import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked/stacked.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class EmotionDetectionViewModel extends BaseViewModel {
  late CameraController _cameraController;
  late Interpreter _interpreter;
  // final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isCameraInitialized = false;
  int k = 0;
  String currentEmotion = "Unknown";
  Timer? _emotionDetectionTimer;

  CameraController get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;

  Future<void> initialize() async {
    if (!_isCameraInitialized) {
      await _initCamera();
    }
    await _loadModel();
    // _initNotifications();
    _startEmotionDetection();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    // Find the front camera
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first, // Fallback if no front camera is found
    );

    // Dispose existing controller before initializing a new one
    if (_isCameraInitialized) {
      await _cameraController.dispose();
    }

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController.initialize();
    _isCameraInitialized = true;
    notifyListeners();
  }

  Future<void> _loadModel() async {
    try {
      final options = InterpreterOptions();
      _interpreter =
          await Interpreter.fromAsset('assets/model.tflite', options: options);
      debugPrint("TFLite Model loaded successfully.");
      Tensor inputTensor = _interpreter.getInputTensor(0);
      debugPrint("Model Input Shape: ${inputTensor.shape}");
      debugPrint("Model Input Type: ${inputTensor.type}");
    } catch (e) {
      debugPrint("Error loading TFLite model: $e");
    }
  }

  // void _initNotifications() {
  //   const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final InitializationSettings initSettings = InitializationSettings(android: androidSettings);
  //   _notificationsPlugin.initialize(initSettings);
  // }

  Future<void> _startEmotionDetection() async {
    // Cancel any existing timer before starting a new one
    _emotionDetectionTimer?.cancel();

    _emotionDetectionTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_isCameraInitialized) return; // Prevent using a disposed camera
      await _captureAndAnalyze();
    });
  }

  Future<void> _captureAndAnalyze() async {
    if (!_isCameraInitialized) return;

    final XFile imageFile = await _cameraController.takePicture();
    final emotion = await _analyzeImage(File(imageFile.path));

    currentEmotion = emotion;
    if (emotion == 'sad') {
      k++;
      if (k == 3) {
        // _sendNotification();
      }
    } else {
      k = 0;
    }
    notifyListeners();
  }

  Future<String> _analyzeImage(File imageFile) async {
    if (_interpreter == null) {
      debugPrint("❌ Error: TFLite Interpreter is not initialized.");
      return "Unknown";
    }

    try {
      // Load the image as bytes
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        debugPrint("❌ Error: Failed to decode image.");
        return "Unknown";
      }

      // Resize the image to 224x224
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Convert image to tensor format (224x224x3)
      List<List<List<double>>> inputTensor = _convertToRGB(resizedImage);

      // Ensure correct input shape: [1, 224, 224, 3]
      var input = [inputTensor];

      // Prepare output buffer
      var outputTensor =
          List.filled(1 * 7, 0).reshape([1, 7]); // Adjust for 7 classes

      // Run inference
      _interpreter.run(input, outputTensor);

      // Get the highest confidence score index
      double maxConfidence =
          outputTensor[0].reduce((double a, double b) => a > b ? a : b);
      int predictedIndex =
          outputTensor[0].indexWhere((value) => value == maxConfidence);

      // Emotion labels (Adjust according to your model)
      List<String> emotionLabels = [
        "angry",
        "disgust",
        "fear",
        "happy",
        "neutral",
        "sad",
        "surprise"
      ];

      String predictedEmotion = emotionLabels[predictedIndex];

      debugPrint("🎭 Detected Emotion: $predictedEmotion");

      return predictedEmotion;
    } catch (e) {
      debugPrint("❌ Error during TFLite inference: $e");
      return "Unknown";
    }
  }

  List<List<List<double>>> _convertToRGB(img.Image image) {
    List<List<List<double>>> rgbImage = [];

    for (int y = 0; y < image.height; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);

        // Normalize RGB values (0-255 → 0-1)
        double red = pixel.r.toDouble() / 255.0;
        double green = pixel.g.toDouble() / 255.0;
        double blue = pixel.b.toDouble() / 255.0;

        row.add([red, green, blue]); // [R, G, B] format
      }
      rgbImage.add(row);
    }

    return rgbImage;
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

  @override
  void dispose() {
    _emotionDetectionTimer?.cancel();
    if (_isCameraInitialized) {
      _cameraController.dispose();
      _isCameraInitialized = false;
    }
    _interpreter.close();
    super.dispose();
  }
}
