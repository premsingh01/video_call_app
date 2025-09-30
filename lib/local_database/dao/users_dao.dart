import 'package:sqflite/sqflite.dart';
import 'package:video_call_app/local_database/tables/users_table.dart';
import '../app_database.dart';

class UsersDao {
  // Insert or update multiple users
  Future<void> insertUsers({required List<Map<String, dynamic>> users}) async {
    final db = await AppDatabase.database;
    Batch batch = db.batch();
    for (var u in users) {
      batch.insert(
        UsersTable.tableName,
        u,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await AppDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(UsersTable.tableName);
    return maps;
    // return maps.map((map) => User.fromMap(map)).toList();
  }

  // Clear table
  Future<void> clearUsers() async {
    final db = await AppDatabase.database;
    await db.delete(UsersTable.tableName);
  }
}