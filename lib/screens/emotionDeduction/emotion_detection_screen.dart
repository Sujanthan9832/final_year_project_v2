import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'emotion_detection_view_model.dart';

class EmotionDetectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmotionDetectionViewModel()
        ..initialize().catchError((error) {
          // Handle initialization errors (e.g., no front camera)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }),
      child: Scaffold(
        appBar: AppBar(title: Text('Emotion Detection')),
        body: _EmotionDetectionBody(),
      ),
    );
  }
}

class _EmotionDetectionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmotionDetectionViewModel>(context);

    if (viewModel.cameraController == null ||
        !viewModel.cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: CameraPreview(viewModel.cameraController!),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Sad Count: ${viewModel.k}',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
