import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule_item.dart';

class ScheduleRepository {
  static const String _storageKey = 'local_schedule_items_v1';
  static const String _nextIdKey = 'local_schedule_next_id_v1';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<List<ScheduleItem>> _readAllRaw() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => ScheduleItem.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _writeAllRaw(List<ScheduleItem> items) async {
    final prefs = await _prefs;
    final encoded = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<int> insert(ScheduleItem item) async {
    final prefs = await _prefs;
    final items = await _readAllRaw();
    final nextId = (prefs.getInt(_nextIdKey) ?? 0) + 1;
    await prefs.setInt(_nextIdKey, nextId);

    final withId = item.copyWith(id: nextId);
    items.add(withId);
    await _writeAllRaw(items);
    return nextId;
  }

  Future<int> update(ScheduleItem item) async {
    if (item.id == null) {
      throw ArgumentError('ScheduleItem must have an id to be updated.');
    }
    final items = await _readAllRaw();
    final index = items.indexWhere((e) => e.id == item.id);
    if (index == -1) return 0;

    items[index] = item;
    await _writeAllRaw(items);
    return 1;
  }

  Future<int> delete(int id) async {
    final items = await _readAllRaw();
    final beforeCount = items.length;
    items.removeWhere((e) => e.id == id);
    if (items.length == beforeCount) return 0;

    await _writeAllRaw(items);
    return 1;
  }

  Future<List<ScheduleItem>> getAll() async {
    final items = await _readAllRaw();
    items.sort((a, b) {
      final dayCmp = a.dayOfWeek.compareTo(b.dayOfWeek);
      if (dayCmp != 0) return dayCmp;
      final timeA = a.timeHour * 60 + a.timeMinute;
      final timeB = b.timeHour * 60 + b.timeMinute;
      return timeA.compareTo(timeB);
    });
    return items;
  }

  Future<List<ScheduleItem>> getByDay(int dayOfWeek) async {
    final items = await getAll();
    return items.where((item) => item.dayOfWeek == dayOfWeek).toList();
  }
}
