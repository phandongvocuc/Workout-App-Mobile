import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/repositories/prefs_repository.dart';
import 'data/repositories/schedule_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_settings_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize notification service and timezone database
  final notificationService = NotificationService();
  await notificationService.initialize();

  // 2. Initialize SharedPreferences & repositories
  final prefsRepository = await PrefsRepository.create();
  final scheduleRepository = ScheduleRepository();

  // 3. Initialize providers
  final authProvider = AuthProvider(prefsRepository);
  final themeProvider = ThemeProvider(prefsRepository);
  final notificationSettingsProvider =
      NotificationSettingsProvider(prefsRepository);
  final scheduleProvider = ScheduleProvider(scheduleRepository);

  // 4. Load locally saved weekly schedule and resync notifications
  await scheduleProvider.loadSchedule(
    leadMinutes: notificationSettingsProvider.reminderLeadMinutes,
    notificationsEnabled: notificationSettingsProvider.notificationsEnabled,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<NotificationSettingsProvider>.value(
          value: notificationSettingsProvider,
        ),
        ChangeNotifierProvider<ScheduleProvider>.value(value: scheduleProvider),
      ],
      child: const HydroFitApp(),
    ),
  );
}
