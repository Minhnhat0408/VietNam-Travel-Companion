import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void themeOnChanged() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

