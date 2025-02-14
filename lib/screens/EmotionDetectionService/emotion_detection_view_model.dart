import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:stress_management_app/services/localNotification.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/material.dart';

class EmotionDetectionViewModel extends ChangeNotifier {
  CameraController? _cameraController;
  Interpreter? _interpreter;
  int _sadCount = 0;
  final int _sadThreshold = 3;
  final int _triggerTime = 5;
  String _currentEmotion = "Detecting...";
  final NotificationService _notificationService = NotificationService();
  CameraController get cameraController => _cameraController!;
  bool isCameraInitialized = false;

  String get currentEmotion => _currentEmotion;

  int get sadCount => _sadCount;

  /// Initialize camera and load TFLite model
  Future<void> initialize(BuildContext context) async {
    await _initializeCamera();
    await _loadModel();
    await _notificationService.initialize(context);
    _startEmotionDetection();

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  /// Setup front camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController!.initialize();

    isCameraInitialized = true; // ✅ Set flag to true when initialized
    notifyListeners(); // ✅ Notify UI about state change
  }

  /// Load TFLite model
  Future<void> _loadModel() async {
    try {
      final options = InterpreterOptions();
      _interpreter =
          await Interpreter.fromAsset('assets/model.tflite', options: options);
      debugPrint("✅ TFLite Model loaded successfully.");
    } catch (e) {
      debugPrint("❌ Error loading TFLite model: $e");
      _interpreter = null; // Ensure it's null if loading fails
    }
  }

  /// Capture an image every 10 seconds and analyze it
  void _startEmotionDetection() {
    Timer.periodic(Duration(seconds: _triggerTime), (timer) async {
      await _captureAndAnalyze();
    });
  }

  /// Capture an image and analyze the emotion
  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint("❌ Camera not initialized.");
      return;
    }

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      String detectedEmotion = await _analyzeImage(File(imageFile.path));
      _currentEmotion = detectedEmotion;

      debugPrint("🎭 Detected Emotion: $detectedEmotion");

      if (detectedEmotion == "sad") {
        _sadCount++;
      } else {
        _sadCount = 0;
      }

      if (_sadCount >= _sadThreshold) {
        _sendNotification();
        _sadCount = 0; // Reset after notification
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error capturing image: $e");
    }
  }

  Future<void> _sendNotification() async {
    await _notificationService.sendNotification();
  }

  /// Analyze image using TFLite model
  Future<String> _analyzeImage(File imageFile) async {
    if (_interpreter == null) {
      debugPrint("❌ Error: TFLite Interpreter is not initialized.");
      return "Unknown";
    }

    try {
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        debugPrint("❌ Error: Failed to decode image.");
        return "Unknown";
      }

      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
      List<List<List<double>>> inputTensor = _convertToRGB(resizedImage);

      var input = [inputTensor];
      var outputTensor = List.filled(1 * 7, 0).reshape([1, 7]);

      _interpreter!.run(input, outputTensor);

      double maxConfidence =
          outputTensor[0].reduce((double a, double b) => a > b ? a : b);
      int predictedIndex =
          outputTensor[0].indexWhere((value) => value == maxConfidence);

      List<String> emotionLabels = [
        "angry",
        "disgust",
        "fear",
        "happy",
        "neutral",
        "sad",
        "surprise"
      ];
      return emotionLabels[predictedIndex];
    } catch (e) {
      debugPrint("❌ Error during TFLite inference: $e");
      return "Unknown";
    }
  }

  /// Convert image to RGB tensor format
  List<List<List<double>>> _convertToRGB(img.Image image) {
    List<List<List<double>>> rgbImage = [];
    for (int y = 0; y < image.height; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < image.width; x++) {
        img.Pixel pixel = image.getPixel(x, y);
        row.add([pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0]);
      }
      rgbImage.add(row);
    }
    return rgbImage;
  }

  /// Dispose resources
  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }
}
