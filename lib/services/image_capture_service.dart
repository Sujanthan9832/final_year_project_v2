import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stress_management_app/screens/EmotionDetectionService/emotion_detection_view_model.dart';

class ImageCaptureService {
  static Future<void> captureImage() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.first;

    final CameraController cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    await cameraController.initialize();

    final XFile picture = await cameraController.takePicture();

    final directory = await getApplicationDocumentsDirectory();
    final String imagePath =
        '${directory.path}/captured_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picture.path).copy(imagePath);

    // Analyze emotion using ViewModel
    EmotionDetectionViewModel viewModel = EmotionDetectionViewModel();
    String detectedEmotion = await viewModel.analyzeImage(File(imagePath));

    if (detectedEmotion == "sad") {
      viewModel.incrementSadCount(); // Create this method in ViewModel
    }

    await cameraController.dispose();
  }
}
