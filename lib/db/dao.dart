import 'package:sqflite/sql.dart';
import 'package:who_owes_me/db/db.dart';

class Dao {
  DB _db = DB();

  // Basic methods
 
  Future<List<Map<String, Object?>>> getById(String tableName, int id) async =>
    (await (await _db.get()).query(tableName, where: 'id = ?', whereArgs: [id]));

  Future<List<Map<String, Object?>>> getAll(String tableName) async =>
    await (await _db.get()).query(tableName);

  Future<int> put(String tableName, Map<String, Object?> data) async =>
    await (await _db.get()).insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  
  Future<int> insert(String tableName, Map<String, Object?> data) async =>
    await (await _db.get()).insert(tableName, data);

  Future<int> update(String tableName, int id, Map<String, Object?> data) async =>
    await (await _db.get()).update(tableName, data, where: 'id = ?', whereArgs: [id]);

  Future<int> delete(String tableName, int id) async =>
    await (await _db.get()).delete(tableName, where: 'id = ?', whereArgs: [id]);
}
