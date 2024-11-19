import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'sqlite_database.dart';

class SQLiteDatabaseImpl implements SQLiteDatabase {
  static final SQLiteDatabaseImpl instance = SQLiteDatabaseImpl._init();
  static Database? _database;

  SQLiteDatabaseImpl._init();

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  @override
  Future<void> initialize() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            zipCode TEXT ,
            address TEXT,
            number TEXT,
            complement TEXT
          )
        ''');
      },
    );
  }
}
