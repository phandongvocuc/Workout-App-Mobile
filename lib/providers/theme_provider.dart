import 'package:flutter/material.dart';
import '../data/repositories/prefs_repository.dart';

class ThemeProvider extends ChangeNotifier {
  final PrefsRepository _prefsRepository;
  late ThemeMode _themeMode;

  ThemeProvider(this._prefsRepository) {
    _themeMode = _prefsRepository.getThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefsRepository.setThemeMode(mode);
  }
}

