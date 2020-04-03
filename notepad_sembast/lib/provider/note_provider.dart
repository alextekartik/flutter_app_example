import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:tekartik_notepad_sembast_app/model/model.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';

DbNote snapshotToNote(RecordSnapshot<int, Map<String, dynamic>> snapshot) {
  DbNote note;
  if (snapshot != null) {
    note = DbNote()..fromMap(snapshot.value, id: snapshot.key);
  }
  return note;
}

class DbNotes extends ListBase<DbNote> {
  final List<RecordSnapshot<int, Map<String, dynamic>>> list;
  List<DbNote> _cacheNotes;

  DbNotes(this.list) {
    _cacheNotes = List.generate(list.length ?? 0, (index) => null);
  }

  @override
  DbNote operator [](int index) {
    return _cacheNotes[index] ??= snapshotToNote(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, DbNote value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbNoteProvider {
  static const String dbName = 'notes.db';
  static const int kVersion1 = 1;
  static final String notesStoreName = 'notes';
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory;
  Database db;

  final notesStore = intMapStoreFactory.store(notesStoreName);

  DbNoteProvider(this.dbFactory);

  Future openPath(String path) async {
    db = await dbFactory.openDatabase(path,
        version: kVersion1, onVersionChanged: _onVersionChanged);
  }

  Future<Database> get ready async => db ??= await lock.synchronized(() async {
        if (db == null) {
          await open();
        }
        return db;
      });

  Future<DbNote> getNote(int id) async {
    var map = await notesStore.record(id).get(db);
    // devPrint('getNote: ${map}');
    if (map != null) {
      return DbNote()..fromMap(map, id: id);
    }
    return null;
  }

  void _onVersionChanged(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < kVersion1) {
      await notesStore.addAll(db, [
        (DbNote()
              ..title.v = 'Simple title'
              ..content.v = 'Simple content'
              ..date.v = 1)
            .toMap(),
        (DbNote()
              ..title.v = 'Welcome to NotePad'
              ..content.v =
                  'Enter your notes\n\nThis is a content. Just tap anywhere to edit the note.\n'
                      '${kIsWeb ? '\nYou can open multiple tabs or windows and see that the content is the same in all tabs' : ''}'
              ..date.v = 2)
            .toMap(),
      ]);
    }
  }

  Future open() async {
    await openPath(await fixPath(dbName));
  }

  Future<String> fixPath(String path) async => path;

  Future saveNote(DbNote updatedNote) async {
    if (updatedNote.id.v != null) {
      await notesStore.record(updatedNote.id.v).put(db, updatedNote.toMap());
    } else {
      updatedNote.id.v = await notesStore.add(db, updatedNote.toMap());
    }
  }

  Future deleteNote(int id) async {
    if (id != null) {
      await notesStore.record(id).delete(db);
    }
  }

  var notesTransformer = StreamTransformer<
      List<RecordSnapshot<int, Map<String, dynamic>>>,
      List<DbNote>>.fromHandlers(handleData: (snapshotList, sink) {
    sink.add(DbNotes(snapshotList));
  });

  var noteTransformer = StreamTransformer<
      RecordSnapshot<int, Map<String, dynamic>>,
      DbNote>.fromHandlers(handleData: (snapshot, sink) {
    sink.add(snapshotToNote(snapshot));
  });

  /// Listen for changes on any note
  Stream<List<DbNote>> onNotes() {
    return notesStore
        .query(finder: Finder(sortOrders: [SortOrder('date', false)]))
        .onSnapshots(db)
        .transform(notesTransformer);
  }

  /// Listed for changes on a given note
  Stream<DbNote> onNote(int id) {
    return notesStore.record(id).onSnapshot(db).transform(noteTransformer);
  }

  Future clearAllNotes() async {
    await notesStore.delete(db);
  }

  Future close() async {
    await db.close();
  }

  Future deleteDb() async {
    await dbFactory.deleteDatabase(await fixPath(dbName));
  }
}
