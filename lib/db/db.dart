import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:who_owes_me/db/table.dart';
import 'package:who_owes_me/models/pay.dart';
import 'package:who_owes_me/models/user.dart';
import 'dart:math';

const String DB_NAME = 'who_owes_me.db';

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
      paid INTEGER,
      FOREIGN KEY (user_id) REFERENCES ${DBTable.user} (id)
    )
  """
  ];

  Future<void> init(Database db) async {
    for (final query in allCreateQueries) db.execute(query).catchError((err) => print(err));
  }

  Future<void> seed(Database db) async {
    Random r = Random();

    User user = User(
      name: 'Jeannette Checo',
      email: 'example@example.com',
      phone: '+18093701462',
    );

    db.insert(DBTable.user, user.toMap());

    for (int i = 0; i < 11; i++) {
      Pay pay = Pay(
        amount: r.nextInt(2000) + 100,
        date: DateTime.now(),
        title: 'Pay ${r.nextInt(100)+1}',
        paid: r.nextBool(),
        userId: 1
      );
      
      db.insert(DBTable.pay, pay.toMap());
    }
  }

  Future<Database> get() async {
    return openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        init(db);
        seed(db);

        // for (final query in allFillQueries) db.execute(query).catchError((err) => print(err));
      },
      version: 1
    );
  }
}