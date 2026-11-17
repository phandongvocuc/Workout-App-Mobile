import 'package:flutter/foundation.dart';
import '../data/models/schedule_item.dart';
import '../data/repositories/schedule_repository.dart';
import '../services/notification_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _repository;
  final NotificationService _notificationService = NotificationService();

  List<ScheduleItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  ScheduleProvider(this._repository);

  List<ScheduleItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isEmpty => _items.isEmpty;

  Map<int, List<ScheduleItem>> get groupedByDay {
    final Map<int, List<ScheduleItem>> map = {
      1: [], // Mon
      2: [], // Tue
      3: [], // Wed
      4: [], // Thu
      5: [], // Fri
      6: [], // Sat
      7: [], // Sun
    };

    for (final item in _items) {
      map.putIfAbsent(item.dayOfWeek, () => []).add(item);
    }

    // Sort items within each day
    for (final list in map.values) {
      list.sort((a, b) {
        final timeA = a.timeHour * 60 + a.timeMinute;
        final timeB = b.timeHour * 60 + b.timeMinute;
        return timeA.compareTo(timeB);
      });
    }

    return map;
  }

  Future<void> loadSchedule({int leadMinutes = 60, bool notificationsEnabled = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _repository.getAll();
      _isLoading = false;
      notifyListeners();

      // On app launch, resync all notifications from DB
      await _notificationService.resyncAllReminders(
        items: _items,
        leadMinutes: leadMinutes,
        notificationsEnabled: notificationsEnabled,
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load schedule: $e';
      notifyListeners();
    }
  }

  Future<void> addItem({
    required ScheduleItem item,
    required int leadMinutes,
    required bool notificationsEnabled,
  }) async {
    try {
      final insertedId = await _repository.insert(item);
      final newItem = item.copyWith(id: insertedId);
      _items.add(newItem);
      notifyListeners();

      // Schedule notification
      await _notificationService.scheduleWorkoutReminder(
        item: newItem,
        leadMinutes: leadMinutes,
        notificationsEnabled: notificationsEnabled,
      );
    } catch (e) {
      _errorMessage = 'Failed to add workout: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateItem({
    required ScheduleItem item,
    required int leadMinutes,
    required bool notificationsEnabled,
  }) async {
    if (item.id == null) return;
    try {
      await _repository.update(item);
      final index = _items.indexWhere((e) => e.id == item.id);
      if (index != -1) {
        _items[index] = item;
      }
      notifyListeners();

      // Cancel existing and reschedule
      await _notificationService.cancelWorkoutReminder(item.id!);
      await _notificationService.scheduleWorkoutReminder(
        item: item,
        leadMinutes: leadMinutes,
        notificationsEnabled: notificationsEnabled,
      );
    } catch (e) {
      _errorMessage = 'Failed to update workout: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _repository.delete(id);
      _items.removeWhere((e) => e.id == id);
      notifyListeners();

      // Cancel notification
      await _notificationService.cancelWorkoutReminder(id);
    } catch (e) {
      _errorMessage = 'Failed to delete workout: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resyncNotifications({
    required int leadMinutes,
    required bool notificationsEnabled,
  }) async {
    await _notificationService.resyncAllReminders(
      items: _items,
      leadMinutes: leadMinutes,
      notificationsEnabled: notificationsEnabled,
    );
  }
}

