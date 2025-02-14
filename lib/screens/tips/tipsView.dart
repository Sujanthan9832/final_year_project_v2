import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'tipsViewModel.dart';

class TipsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TipsViewModel>.reactive(
      viewModelBuilder: () => TipsViewModel(),
      onViewModelReady: (viewModel) => viewModel.fetchAllTips(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Tips")),
          body: viewModel.isBusy
              ? Center(child: CircularProgressIndicator())
              : viewModel.tips.isEmpty
                  ? Center(child: Text("No tips found"))
                  : ListView.builder(
                      itemCount: viewModel.tips.length,
                      itemBuilder: (context, index) {
                        var tip = viewModel.tips[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(tip["title"] ?? "No Title",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle:
                                Text(tip["description"] ?? "No Description"),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
