import 'dart:ffi';
import 'package:flutter/material.dart';

CustomTheme currenttheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currenttheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  Void? toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData? get lightTheme {
    return ThemeData(
      primaryColor: Colors.lightBlue,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
      ),
    );
  }

  static ThemeData? get darkTheme {
    return ThemeData(
      primaryColor: const Color.fromRGBO(7, 84, 94, 0.9),
      backgroundColor: const Color.fromRGBO(7, 84, 94, 0.9),
      scaffoldBackgroundColor: const Color.fromRGBO(7, 84, 94, 0.9),
      textTheme: const TextTheme(
        headline1: TextStyle(
          color: Colors.white,
        ),
        headline2: TextStyle(
          color: Colors.white,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
