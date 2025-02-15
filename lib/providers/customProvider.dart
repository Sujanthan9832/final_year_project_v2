import 'package:flutter/material.dart';
import 'package:stress_management_app/constants/theme.dart';

class CustomProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}
