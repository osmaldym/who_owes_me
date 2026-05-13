import 'package:sqflite/sql.dart';
import 'package:who_owes_me/db/db.dart';
import 'package:who_owes_me/db/table.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/user.dart';
import 'package:who_owes_me/utils/DBConvertions.dart';

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

  Future<int> putUser(User user) => put(DBTable.user, user.toMap());
  
  Future<List<User>> getAllUsers() async => DBConvertions.responseToUserList(await getAll(DBTable.user));

  Future<int> putPay(Pay pay) => put(DBTable.pay, pay.toMap());
  
  Future<List<Pay>> getAllPays() async => DBConvertions.responseToPayList(await getAll(DBTable.pay));
}
