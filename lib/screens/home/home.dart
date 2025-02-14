import 'package:flutter/material.dart';
import 'package:stress_management_app/screens/EmotionDetectionService/emotion_detection_service_screen.dart';
import 'package:stress_management_app/screens/camScreen/camView.dart';
import 'package:stress_management_app/screens/emotionDeduction/emotion_detection_screen.dart';
import 'package:stress_management_app/screens/tips/tipsView.dart';
import 'package:stress_management_app/widgets/custom_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Camview(),
    // EmotionDetectionScreen(),
    TipsView(),
    EmotionDetectionServiceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(1);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0), // Round shape
          side: BorderSide(
            color:
                Theme.of(context).colorScheme.primaryContainer, // Border color
            width: 2.0, // Border width
          ),
        ),
        // shape: const CircleBorder(),
        // backgroundColor: colors.brandWhite,
        // foregroundColor: colors.brandBlack
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: _selectedIndex == 2
            ? Color.fromARGB(255, 255, 255, 255)
            : Color.fromARGB(255, 0, 0, 0),
        child: const Icon(Icons.camera),
        // elevation: 0,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex, // Pass the current selected index
        onItemSelected: _onItemTapped, // Pass the callback
      ),
    );
  }
}
