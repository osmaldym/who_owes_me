import 'package:sqflite/sql.dart';
import 'package:who_owes_me/db/db.dart';
import 'package:who_owes_me/db/table.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/realated_pay.dart';
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

  // Users

  Future<int> putUser(User user) => put(DBTable.user, user.toMap());
  
  Future<List<User>> getAllUsers() async => DBConvertions.responseToUserList(await getAll(DBTable.user));

  // Pays
  
  Future<int> putPay(Pay pay) => put(DBTable.pay, pay.toMap());
  
  Future<List<Pay>> getAllPays() async => DBConvertions.responseToPayList(await getAll(DBTable.pay));

  // Related pays

  Future<RelatedPay> _toRelatedPay(Pay pay) async => RelatedPay(
    id: pay.id,
    title: pay.title,
    amount: pay.amount,
    date: pay.date,
    userId: pay.userId,
    user: DBConvertions.responseToUser((await getById(DBTable.user, pay.userId!)).first),
  );

  Future<List<RelatedPay>> _toRelatedPays(List<Pay> pays) async => [
    for (final pay in pays) await _toRelatedPay(pay)
  ];

  // Overviews

  Future<double> getTotalDue() async {
    List<Map<String, Object?>> pays = (await (await _db.get()).rawQuery("SELECT SUM(amount) as total_due FROM ${DBTable.pay}"));
    if (pays.isNotEmpty) return pays.first['total_due'] as double;
    return 0;
  }

  Future<List<RelatedPay>> getNextPays() async {
    List<Map<String, Object?>> payMaps = (await (await _db.get()).query(DBTable.pay, limit: 5, orderBy: "date ASC", where: "date != ?", whereArgs: ['null']));
    List<Pay> payList = DBConvertions.responseToPayList(payMaps);
    return _toRelatedPays(payList);
  }

  Future<List<Map<String, Object?>>> getUsersOweMost() async {
    List<Map<String, Object?>> userMaps = (await (await _db.get()).rawQuery("""
      SELECT
        u.*,
        SUM(p.amount) as owe_total
      FROM ${DBTable.pay} AS p
      INNER JOIN ${DBTable.user} AS u ON u.id = p.user_id
      GROUP BY u.id
      ORDER BY owe_total DESC
      LIMIT 5
    """));

    return userMaps;
  }
}
