import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import './emotion_detection_view_model.dart';

class EmotionDetectionServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmotionDetectionViewModel>.reactive(
      viewModelBuilder: () => EmotionDetectionViewModel(),
      onViewModelReady: (viewModel) => viewModel.initialize(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Emotion Detection')),
          body: viewModel.isCameraInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    CameraPreview(viewModel.cameraController!),
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          Text(
                            "Emotion: ${viewModel.currentEmotion}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Sad Count: ${viewModel.sadCount}",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
