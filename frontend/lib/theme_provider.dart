import 'package:flutter/material.dart';

// Global theme notifier
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// Light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
);

// Dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
);
