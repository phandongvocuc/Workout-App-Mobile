import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyReminderLeadMinutes = 'reminder_lead_minutes';

  final SharedPreferences _prefs;

  PrefsRepository(this._prefs);

  static Future<PrefsRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsRepository(prefs);
  }

  // Theme Mode
  ThemeMode getThemeMode() {
    final value = _prefs.getString(_keyThemeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await _prefs.setString(_keyThemeMode, value);
  }

  // Notifications Enabled
  bool getNotificationsEnabled() {
    return _prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  // Reminder Lead Time (minutes)
  // Options: 30 (30m), 60 (1h), 360 (6h), 720 (12h). Default: 60
  int getReminderLeadMinutes() {
    return _prefs.getInt(_keyReminderLeadMinutes) ?? 60;
  }

  Future<void> setReminderLeadMinutes(int minutes) async {
    await _prefs.setInt(_keyReminderLeadMinutes, minutes);
  }
}

