import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/models/schedule_item.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String channelRemindersId = 'workout_reminders';
  static const String channelRemindersName = 'Workout Reminders';
  static const String channelRemindersDesc =
      'Scheduled weekly reminders for HydroFit workouts';

  static const String channelTimerId = 'timer_completion';
  static const String channelTimerName = 'Exercise Timer';
  static const String channelTimerDesc =
      'Alert when exercise countdown timer completes';

  static const int timerNotificationId = 999999;
  static const int instantTimerNotificationId = 999998;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Initialize timezone database
    tz.initializeTimeZones();
    _configureLocalTimeZone();

    // 2. Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // 3. Create Android notification channels
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          channelRemindersId,
          channelRemindersName,
          description: channelRemindersDesc,
          importance: Importance.max,
          enableVibration: true,
          playSound: true,
        ),
      );

      await androidImplementation.createNotificationChannel(
        const AndroidNotificationChannel(
          channelTimerId,
          channelTimerName,
          description: channelTimerDesc,
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        ),
      );
    }

    _isInitialized = true;
  }

  void _configureLocalTimeZone() {
    try {
      final String timeZoneName = DateTime.now().timeZoneName;
      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } catch (_) {
        // Fallback: search for location matching abbreviation or offset
        final match = tz.timeZoneDatabase.locations.keys.firstWhere(
          (key) =>
              tz.timeZoneDatabase.locations[key]?.currentTimeZone.abbreviation ==
              timeZoneName,
          orElse: () => 'UTC',
        );
        tz.setLocalLocation(tz.getLocation(match));
      }
    } catch (e) {
      debugPrint('Fallback to UTC timezone: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return true;
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  NotificationDetails _buildReminderNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      channelRemindersId,
      channelRemindersName,
      channelDescription: channelRemindersDesc,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );
    return const NotificationDetails(android: androidDetails);
  }

  NotificationDetails _buildTimerNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      channelTimerId,
      channelTimerName,
      channelDescription: channelTimerDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );
    return const NotificationDetails(android: androidDetails);
  }

  /// Schedule weekly repeating notification for a workout
  Future<void> scheduleWorkoutReminder({
    required ScheduleItem item,
    required int leadMinutes,
    required bool notificationsEnabled,
  }) async {
    if (!notificationsEnabled || item.id == null) return;

    final targetDateTime = _calculateNextInstance(
      dayOfWeek: item.dayOfWeek,
      hour: item.timeHour,
      minute: item.timeMinute,
      leadMinutes: leadMinutes,
    );

    final String leadText = leadMinutes > 0
        ? 'Starts in ${leadMinutes >= 60 ? "${leadMinutes ~/ 60}h" : "${leadMinutes}m"}'
        : 'Starting now';

    final String body = item.description != null && item.description!.isNotEmpty
        ? '$leadText • ${item.description}'
        : '$leadText • Time to get moving!';

    await _scheduleWithFallback(
      id: item.id!,
      title: 'Workout Reminder: ${item.title}',
      body: body,
      scheduledDate: targetDateTime,
      details: _buildReminderNotificationDetails(),
      matchComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Cancel reminder by item ID
  Future<void> cancelWorkoutReminder(int itemId) async {
    await _notificationsPlugin.cancel(itemId);
  }

  /// Resync all scheduled workouts from list
  Future<void> resyncAllReminders({
    required List<ScheduleItem> items,
    required int leadMinutes,
    required bool notificationsEnabled,
  }) async {
    // Cancel all previous workout reminders
    await _notificationsPlugin.cancelAll();

    if (!notificationsEnabled) return;

    for (final item in items) {
      if (item.id != null) {
        await scheduleWorkoutReminder(
          item: item,
          leadMinutes: leadMinutes,
          notificationsEnabled: notificationsEnabled,
        );
      }
    }
  }

  /// Fallback notification when user backgrounds app during timer
  Future<void> scheduleTimerFallback({
    required String exerciseName,
    required Duration duration,
  }) async {
    final scheduledDate = tz.TZDateTime.now(tz.local).add(duration);

    await _scheduleWithFallback(
      id: timerNotificationId,
      title: 'Exercise Complete! 🏆',
      body: 'You crushed "$exerciseName"! Tap to return to HydroFit.',
      scheduledDate: scheduledDate,
      details: _buildTimerNotificationDetails(),
    );
  }

  /// Cancel fallback timer notification
  Future<void> cancelTimerFallback() async {
    await _notificationsPlugin.cancel(timerNotificationId);
  }

  /// Show immediate notification when timer completes in app
  Future<void> showTimerCompleteInstant(String exerciseName) async {
    await _notificationsPlugin.show(
      instantTimerNotificationId,
      'Exercise Complete! 🏆',
      'You crushed "$exerciseName"!',
      _buildTimerNotificationDetails(),
    );
  }

  Future<void> _scheduleWithFallback({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    DateTimeComponents? matchComponents,
  }) async {
    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: matchComponents,
      );
    } catch (e) {
      debugPrint('Exact alarm failed ($e), falling back to inexact schedule');
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: matchComponents,
        );
      } catch (e2) {
        debugPrint('Failed to schedule notification: $e2');
      }
    }
  }

  tz.TZDateTime _calculateNextInstance({
    required int dayOfWeek, // 1=Mon .. 7=Sun
    required int hour,
    required int minute,
    required int leadMinutes,
  }) {
    final now = DateTime.now();
    final totalTargetMinutes = (hour * 60 + minute) - leadMinutes;

    int adjustedHour = (totalTargetMinutes ~/ 60);
    int adjustedMinute = totalTargetMinutes % 60;
    int dayOffset = 0;

    if (adjustedMinute < 0) {
      adjustedMinute += 60;
      adjustedHour -= 1;
    }

    while (adjustedHour < 0) {
      adjustedHour += 24;
      dayOffset -= 1;
    }
    while (adjustedHour >= 24) {
      adjustedHour -= 24;
      dayOffset += 1;
    }

    int targetDay = dayOfWeek + dayOffset;
    while (targetDay < 1) {
      targetDay += 7;
    }
    while (targetDay > 7) {
      targetDay -= 7;
    }

    int daysAhead = targetDay - now.weekday;
    if (daysAhead < 0 ||
        (daysAhead == 0 &&
            (now.hour > adjustedHour ||
                (now.hour == adjustedHour && now.minute >= adjustedMinute)))) {
      daysAhead += 7;
    }

    final targetDate = DateTime(
      now.year,
      now.month,
      now.day,
      adjustedHour,
      adjustedMinute,
    ).add(Duration(days: daysAhead));

    return tz.TZDateTime.from(targetDate, tz.local);
  }
}
