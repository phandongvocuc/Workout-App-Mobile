import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _databaseName = 'hydrofit.db';
  static const int _databaseVersion = 1;

  static const String tableSchedule = 'schedule_items';
  static const String colId = 'id';
  static const String colDayOfWeek = 'day_of_week';
  static const String colTimeHour = 'time_hour';
  static const String colTimeMinute = 'time_minute';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colCreatedAt = 'created_at';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSchedule (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colDayOfWeek INTEGER NOT NULL,
        $colTimeHour INTEGER NOT NULL,
        $colTimeMinute INTEGER NOT NULL,
        $colTitle TEXT NOT NULL,
        $colDescription TEXT,
        $colCreatedAt INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

