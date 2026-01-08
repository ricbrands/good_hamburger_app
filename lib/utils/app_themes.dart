import 'package:flutter/material.dart';

class AppThemes {
  static final light = ThemeData(
    primaryColor: const Color(0xFFff5722),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFff5722),
      primary: const Color(0xFFff5722),
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    cardColor: Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFff5722),
      unselectedItemColor: Colors.grey,
    )
  );
}