import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/utils/utils.dart';

const _counterId = 1;

class CounterDatabase {
  final String path;

  late final Future<Database> _db = () async {
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE counter(
          id INTEGER PRIMARY KEY,
          value INTEGER NOT NULL
        );
      ''');
    });
  }();

  CounterDatabase({this.path = 'counter.db'});

  Future<int> _getCounter(DatabaseExecutor client) async {
    return firstIntValue(await client.query('counter',
            columns: ['value'], where: 'id = ?', whereArgs: [_counterId])) ??
        0;
  }

  Future<int> getCounter() async {
    var db = await _db;
    return await _getCounter(db);
  }

  Future<void> incrementCounter() async {
    var db = await _db;
    await db.transaction((txn) async {
      var value = await _getCounter(txn);
      var data = <String, Object?>{'value': ++value};
      if ((await txn.update('counter', data,
              where: 'id = ?', whereArgs: [_counterId]) ==
          0)) {
        await txn.insert('counter', data..['id'] = _counterId);
      }
    });
  }
}
