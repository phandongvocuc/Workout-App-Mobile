import 'package:flutter/material.dart';
import '../data/repositories/prefs_repository.dart';
import '../services/notification_service.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  final PrefsRepository _prefsRepository;
  final NotificationService _notificationService = NotificationService();

  late bool _notificationsEnabled;
  late int _reminderLeadMinutes;
  bool _isPermissionGranted = true;

  NotificationSettingsProvider(this._prefsRepository) {
    _notificationsEnabled = _prefsRepository.getNotificationsEnabled();
    _reminderLeadMinutes = _prefsRepository.getReminderLeadMinutes();
    checkPermissionStatus();
  }

  bool get notificationsEnabled => _notificationsEnabled;
  int get reminderLeadMinutes => _reminderLeadMinutes;
  bool get isPermissionGranted => _isPermissionGranted;

  Future<void> checkPermissionStatus() async {
    _isPermissionGranted = await _notificationService.checkPermission();
    notifyListeners();
  }

  Future<bool> requestNotificationPermission() async {
    final granted = await _notificationService.requestPermission();
    _isPermissionGranted = granted;
    notifyListeners();
    return granted;
  }

  Future<void> openSystemSettings() async {
    await _notificationService.openSettings();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (_notificationsEnabled == enabled) return;
    _notificationsEnabled = enabled;
    notifyListeners();
    await _prefsRepository.setNotificationsEnabled(enabled);
  }

  Future<void> setReminderLeadMinutes(int minutes) async {
    if (_reminderLeadMinutes == minutes) return;
    _reminderLeadMinutes = minutes;
    notifyListeners();
    await _prefsRepository.setReminderLeadMinutes(minutes);
  }
}

