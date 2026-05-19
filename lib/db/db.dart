import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:who_owes_me/db/table.dart';

String DB_NAME = 'who_owes_me.db';

class DB {
  final List<String> allCreateQueries = [
    """
    CREATE TABLE ${DBTable.user} (
      id INTEGER PRIMARY KEY,
      name TEXT,
      email TEXT,
      phone TEXT,
      deleted_at INTEGER
    )
  """,
  """
    CREATE TABLE ${DBTable.pay} (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      title TEXT,
      amount REAL,
      date INTEGER,
      deleted_at INTEGER,
      FOREIGN KEY (user_id) REFERENCES ${DBTable.user} (id)
    )
  """
  ];

  Future<Database> get() async {
    return openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        for (final query in allCreateQueries) db.execute(query).catchError((err) => print(err));

        // for (final query in allFillQueries) db.execute(query).catchError((err) => print(err));
      },
      version: 1
    );
  }
}