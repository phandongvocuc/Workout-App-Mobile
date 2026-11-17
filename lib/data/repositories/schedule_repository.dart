import '../db/database_helper.dart';
import '../models/schedule_item.dart';

class ScheduleRepository {
  final DatabaseHelper _dbHelper;

  ScheduleRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<int> insert(ScheduleItem item) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.tableSchedule,
      item.toMap(),
    );
  }

  Future<int> update(ScheduleItem item) async {
    if (item.id == null) {
      throw ArgumentError('ScheduleItem must have an id to be updated.');
    }
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.tableSchedule,
      item.toMap(),
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.tableSchedule,
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<ScheduleItem>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableSchedule,
      orderBy: '${DatabaseHelper.colDayOfWeek} ASC, ${DatabaseHelper.colTimeHour} ASC, ${DatabaseHelper.colTimeMinute} ASC',
    );
    return maps.map((map) => ScheduleItem.fromMap(map)).toList();
  }

  Future<List<ScheduleItem>> getByDay(int dayOfWeek) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.tableSchedule,
      where: '${DatabaseHelper.colDayOfWeek} = ?',
      whereArgs: [dayOfWeek],
      orderBy: '${DatabaseHelper.colTimeHour} ASC, ${DatabaseHelper.colTimeMinute} ASC',
    );
    return maps.map((map) => ScheduleItem.fromMap(map)).toList();
  }
}

