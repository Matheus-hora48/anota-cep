import 'package:sqflite/sqflite.dart';

abstract class SQLiteDatabase {
  Future<Database> get database;

  Future<void> initialize();
}
