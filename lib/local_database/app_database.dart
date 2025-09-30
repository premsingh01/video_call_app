import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables/users_table.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(UsersTable.createTable);
      },
    );
  }

  static Future<void> close() async {
    final db = await database;
    db.close();
  }
}
