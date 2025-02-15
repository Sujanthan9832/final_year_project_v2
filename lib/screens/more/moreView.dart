import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stress_management_app/providers/locator.dart';
import 'package:stress_management_app/screens/more/moreViewModel.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MoreViewModel>.reactive(
      viewModelBuilder: () => MoreViewModel(),
      onViewModelReady: (viewModel) => viewModel.loadUserData(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("More")),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(viewModel.profileImage),
                      ),
                      const SizedBox(height: 10),

                      // User Name
                      Text(viewModel.userName,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),

                      // Email
                      Text(viewModel.email,
                          style: const TextStyle(fontSize: 16)),

                      const SizedBox(height: 20),

                      // Emotion Analytics
                      const Text(
                        "Emotion Analytics",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Emotion Data (List)
                      Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.emotionData.length,
                          itemBuilder: (context, index) {
                            String emotion =
                                viewModel.emotionData.keys.elementAt(index);
                            double percentage = viewModel.emotionData[emotion]!;
                            return Card(
                              color: colors.brandWhite,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading: const Icon(Icons.analytics),
                                title: Text(emotion),
                                trailing:
                                    Text("${percentage.toStringAsFixed(1)}%"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
