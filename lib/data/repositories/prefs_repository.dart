import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsRepository {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyReminderLeadMinutes = 'reminder_lead_minutes';
  static const String _keyApiBaseUrl = 'api_base_url';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserJson = 'auth_user_json';

  static const String defaultApiBaseUrl = 'http://10.0.2.2:8080';

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
  int getReminderLeadMinutes() {
    return _prefs.getInt(_keyReminderLeadMinutes) ?? 60;
  }

  Future<void> setReminderLeadMinutes(int minutes) async {
    await _prefs.setInt(_keyReminderLeadMinutes, minutes);
  }

  // Backend Server URL
  String getApiBaseUrl() {
    return _prefs.getString(_keyApiBaseUrl) ?? defaultApiBaseUrl;
  }

  Future<void> setApiBaseUrl(String url) async {
    await _prefs.setString(_keyApiBaseUrl, url);
  }

  // Auth Session Persistence
  String? getAuthToken() => _prefs.getString(_keyAuthToken);

  Future<void> setAuthToken(String? token) async {
    if (token == null) {
      await _prefs.remove(_keyAuthToken);
    } else {
      await _prefs.setString(_keyAuthToken, token);
    }
  }

  String? getUserJson() => _prefs.getString(_keyUserJson);

  Future<void> setUserJson(String? json) async {
    if (json == null) {
      await _prefs.remove(_keyUserJson);
    } else {
      await _prefs.setString(_keyUserJson, json);
    }
  }
}
