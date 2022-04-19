// ignore_for_file: prefer_const_declarations

import 'dart:async';

import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/map_utils.dart';
import 'package:tekartik_notepad_idb_app/src/import.dart';

const String dbName = 'note.db';

const int kVersion1 = 1;

String fieldTitle = 'title';
String fieldDescription = 'description';

class MemoryNoteProvider extends NoteProvider {
  MemoryNoteProvider() : super(idbFactory: idbFactoryMemory);
}

class NoteProvider {
  final IdbFactory idbFactory;
  late Database db;

  static final String notesStoreName = 'notes';

  NoteProvider({required this.idbFactory});

  // final notesStore = intMapStoreFactory.store(notesStoreName);
  ObjectStore get notesWritableTxn {
    var txn = db.transaction(notesStoreName, idbModeReadWrite);
    var store = txn.objectStore(notesStoreName);
    return store;
  }

  ObjectStore get notesReadableTxn {
    var txn = db.transaction(notesStoreName, idbModeReadOnly);
    var store = txn.objectStore(notesStoreName);
    return store;
  }

  Future<int> getCount() async {
    var store = notesReadableTxn;
    var count = await store.count();
    return count;
  }

  Future<Note?> getNote(int id) async {
    var store = notesReadableTxn;
    var map = asMap<String, Object?>(await store.getObject(id));
    if (map != null) {
      return Note.fromMap(map, id);
    }
    return null;
  }

  Future open() async {
    db = await idbFactory.open(dbName,
        version: kVersion1, onUpgradeNeeded: onUpgradeNeeded);
  }

  void onUpgradeNeeded(VersionChangeEvent event) {
    var db = event.database;
    db.createObjectStore(notesStoreName, autoIncrement: true);
  }

  /// Add if id is null, update otherwise
  Future saveNote(Note note) async {
    // devPrint('saveNote $updatedNote');
    var store = notesWritableTxn;
    if (note.id != null) {
      await store.put(note.toMap(), note.id);
    } else {
      note.id = await store.add(note.toMap()) as int;
    }
  }

  Future deleteNote(int? id) async {
    if (id != null) {
      await notesWritableTxn.delete(id);
    }
  }

  Future<List<Note>> getNotes() async {
    // devPrint('getting $offset $limit');
    List<Note?> list = <Note>[];
    var store = notesReadableTxn;
    // ignore: cancel_subscriptions
    StreamSubscription subscription;
    subscription = store
        .openCursor(direction: idbDirectionPrev, autoAdvance: true)
        .listen((cursor) {
      try {
        var map = asMap<String, Object?>(cursor.value);

        if (map != null) {
          var note = cursorToNote(cursor);
          // devPrint('adding ${note}');
          list.add(note);
        }
      } catch (e) {
        // devPrint('error getting list notes $e');
      }
    });
    await subscription.asFuture();
    return list as FutureOr<List<Note>>;
  }

  Future clearAllNotes() async {
    var store = notesWritableTxn;
    await store.openKeyCursor(autoAdvance: true).listen((cursor) {
      cursor.delete();
    }).asFuture();
  }

  Future close() async {
    db.close();
  }
}

Note? cursorToNote(CursorWithValue/*<int, Map<String, Object?>>*/ cursor) {
  Note? note;
  var snapshot = asMap(cursor.value);
  if (snapshot != null) {
    note = Note.fromMap(snapshot, cursor.primaryKey as int);
  }
  return note;
}

class Note {
  int? id;
  String? title;
  String? description;

  Note({required this.title, required this.description, this.id});

  Map<String, String?> toMap() {
    var map = <String, String?>{
      fieldTitle: title,
      fieldDescription: description
    };
    return map;
  }

  Note.fromMap(Map map, this.id) {
    title = map[fieldTitle] as String?;
    description = map[fieldDescription] as String?;
  }

  @override
  int get hashCode => id ?? 0;

  @override
  bool operator ==(other) {
    return other is Note &&
        other.title == title &&
        other.description == description &&
        other.id == id;
  }
}
