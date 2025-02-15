import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromARGB(255, 233, 245, 233),
    primary: Color.fromARGB(255, 255, 255, 255),
    primaryContainer: Color.fromARGB(255, 241, 241, 241),
    secondary: Color.fromARGB(255, 24, 24, 39),
    secondaryContainer: Color.fromARGB(255, 39, 39, 53),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 0, 0, 17),
    primary: Color.fromARGB(255, 16, 16, 32),
    primaryContainer: Color.fromARGB(255, 24, 24, 39),
    secondary: Color.fromARGB(255, 241, 241, 241),
    secondaryContainer: Color.fromARGB(255, 217, 217, 217),
  ),
);
