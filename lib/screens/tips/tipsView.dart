import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stress_management_app/providers/locator.dart';
import 'tipsViewModel.dart';

class TipsView extends StatelessWidget {
  const TipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TipsViewModel>.reactive(
      viewModelBuilder: () => TipsViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchAllTips(),
      builder: (context, viewModel, child) {
        return Scaffold(
          // appBar: AppBar(title: const Text("Tips for Mind Relax")),
          body: viewModel.isBusy
              ? const Center(child: CircularProgressIndicator())
              : viewModel.tips.isEmpty
                  ? const Center(child: Text("No tips found"))
                  : SafeArea(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            height: 150, // Adjust height as needed
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(15), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  blurRadius: 10, // Soften the shadow
                                  spreadRadius: 2, // Extend the shadow
                                  offset:
                                      const Offset(0, 4), // Move shadow down
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/tips_header2.jpg"), // Replace with your image
                                fit: BoxFit.cover, // Adjust as needed
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Tips for Mind Relax",
                              style: TextStyle(
                                color: colors.brandBlack, // Ensures visibility
                                fontFamily: "Josefin Sans",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors
                                        .black54, // Adds contrast for better readability
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.tips.length,
                              itemBuilder: (context, index) {
                                var tip = viewModel.tips[index];
                                return Card(
                                  color: colors.brandWhite,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    leading: Icon(Icons.lightbulb_outline,
                                        color: colors.brandColor, size: 28),
                                    title: Text(tip["title"] ?? "No Title",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      tip["description"]?.substring(
                                              0,
                                              tip["description"]!.length > 50
                                                  ? 50
                                                  : tip["description"]
                                                      ?.length) ??
                                          "No Description",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () => _showTipDetails(context,
                                        tip["title"], tip["description"]),
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

  /// Show a popup dialog with the full tip description
  void _showTipDetails(
      BuildContext context, String? title, String? description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? "No Title"),
          content: Text(description ?? "No Description"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
