import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tekartik_notepad_sqflite_common/src/model/model_constant.dart';
import 'package:tekartik_notepad_sqflite_common/src/model/note.dart';

DbNote snapshotToNote(Map<String, Object?> snapshot) {
  return DbNote()..fromMap(snapshot);
}

/// Read-only list of notes, converted lazily from the query result.
class DbNotes extends ListBase<DbNote> {
  final List<Map<String, Object?>> list;
  late final List<DbNote?> _cacheNotes;

  DbNotes(this.list) {
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  DbNote operator [](int index) {
    return _cacheNotes[index] ??= snapshotToNote(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, DbNote? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

/// Notes stored in a sqflite database, [dbFactory] being the factory of the
/// platform chosen by the app (sqflite plugin, sqflite_ffi,
/// sqflite_common_ffi_web...).
class DbNoteProvider {
  final _lock = Lock();
  final DatabaseFactory dbFactory;
  final _updateTriggerController = StreamController<bool>.broadcast();
  Database? db;

  DbNoteProvider(this.dbFactory);

  Future<void> openPath(String path) async {
    db = await dbFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: kVersion1,
        onCreate: (db, version) async {
          await _createDb(db);
        },
      ),
    );
  }

  void _triggerUpdate() {
    _updateTriggerController.sink.add(true);
  }

  /// Opens the database once.
  Future<Database> get ready async =>
      db ??
      await _lock.synchronized(() async {
        if (db == null) {
          await open();
        }
        return db!;
      });

  Future<DbNote?> getNote(int? id) async {
    var list = await db!.query(
      tableNotes,
      columns: [columnId, columnTitle, columnContent, columnUpdated],
      where: '$columnId = ?',
      whereArgs: <Object?>[id],
    );
    if (list.isNotEmpty) {
      return snapshotToNote(list.first);
    }
    return null;
  }

  Future<void> _createDb(Database db) async {
    await db.execute(
      'CREATE TABLE $tableNotes($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnContent TEXT, $columnUpdated INTEGER)',
    );
    await db.execute(
      'CREATE INDEX NotesUpdated ON $tableNotes ($columnUpdated)',
    );
    await _saveNote(
      db,
      DbNote()
        ..title.v = 'Simple title'
        ..content.v = 'Simple content'
        ..date.v = 1,
    );
    await _saveNote(
      db,
      DbNote()
        ..title.v = 'Welcome to NotePad'
        ..content.v =
            'Enter your notes\n\nThis is a content. Just tap anywhere to edit the note.\n'
            '${kIsWeb ? '\nYou can open multiple tabs or windows and see that the content is the same in all tabs' : ''}'
        ..date.v = 2,
    );
    _triggerUpdate();
  }

  /// Opens [dbName], relative to the databases path of [dbFactory].
  Future<void> open() async {
    await openPath(dbName);
  }

  /// Add or update a note.
  Future<void> _saveNote(DatabaseExecutor db, DbNote updatedNote) async {
    if (updatedNote.id.v != null) {
      await db.update(
        tableNotes,
        updatedNote.toMap(),
        where: '$columnId = ?',
        whereArgs: <Object?>[updatedNote.id.v],
      );
    } else {
      updatedNote.id.v = await db.insert(tableNotes, updatedNote.toMap());
    }
  }

  Future<void> saveNote(DbNote updatedNote) async {
    await _saveNote(db!, updatedNote);
    _triggerUpdate();
  }

  Future<void> deleteNote(int? id) async {
    await db!.delete(
      tableNotes,
      where: '$columnId = ?',
      whereArgs: <Object?>[id],
    );
    _triggerUpdate();
  }

  /// Emits [fetch] now and on every change.
  Stream<T> _onChange<T>(Future<T> Function() fetch) {
    late StreamController<T> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var value = await fetch();
      if (!ctlr.isClosed) {
        ctlr.add(value);
      }
    }

    ctlr = StreamController<T>(
      onListen: () {
        sendUpdate();
        triggerSubscription = _updateTriggerController.stream.listen((_) {
          sendUpdate();
        });
      },
      onCancel: () {
        triggerSubscription?.cancel();
      },
    );
    return ctlr.stream;
  }

  /// Listen for changes on any note.
  Stream<List<DbNote>> onNotes() => _onChange(getListNotes);

  /// Listen for changes on a given note.
  Stream<DbNote?> onNote(int? id) => _onChange(() => getNote(id));

  /// Don't read all fields, newest first unless [descending] is false.
  Future<DbNotes> getListNotes({
    int? offset,
    int? limit,
    bool? descending,
  }) async {
    var list = await db!.query(
      tableNotes,
      columns: [columnId, columnTitle, columnContent],
      orderBy: '$columnUpdated ${(descending ?? true) ? 'DESC' : 'ASC'}',
      limit: limit,
      offset: offset,
    );
    return DbNotes(list);
  }

  Future<void> clearAllNotes() async {
    await db!.delete(tableNotes);
    _triggerUpdate();
  }

  Future<void> close() async {
    await db?.close();
    db = null;
  }

  Future<void> deleteDb() async {
    await dbFactory.deleteDatabase(dbName);
  }
}
