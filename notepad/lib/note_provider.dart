import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idb_shim/idb_client.dart';
import 'package:idb_shim/idb_client_memory.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/map_utils.dart';

const String dbName = "note.db";

const int kVersion1 = 1;

String fieldTitle = "title";
String fieldDescription = "description";

class MemoryNoteProvider extends NoteProvider {
  MemoryNoteProvider() : super(idbFactory: idbFactoryMemory);
}

class NoteProvider {
  final IdbFactory idbFactory;
  Database db;

  static final String notesStoreName = 'notes';

  NoteProvider({@required this.idbFactory});

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

  Future<Note> getNote(int id) async {
    var store = notesReadableTxn;
    Map<String, dynamic> map =
        asMap<String, dynamic>(await store?.getObject(id));
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

  Future deleteNote(int id) async {
    if (id != null) {
      await notesWritableTxn.delete(id);
    }
  }

  Future<List<Note>> getNotes() async {
    // devPrint('getting $offset $limit');
    var list = <Note>[];
    var store = notesReadableTxn;
    // ignore: cancel_subscriptions
    StreamSubscription subscription;
    subscription = store
        .openCursor(direction: idbDirectionPrev, autoAdvance: true)
        .listen((cursor) {
      try {
        var map = asMap<String, dynamic>(cursor.value);

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
    return list;
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

Note cursorToNote(CursorWithValue/*<int, Map<String, dynamic>>*/ cursor) {
  Note note;
  var snapshot = asMap(cursor.value);
  if (snapshot != null) {
    note = Note.fromMap(snapshot, cursor.primaryKey as int);
  }
  return note;
}

class Note {
  int id;
  String title;
  String descritpion;

  Note({@required this.title, @required this.descritpion, this.id});

  Map<String, String> toMap() {
    Map<String, String> map = {
      fieldTitle: title,
      fieldDescription: descritpion
    };
    return map;
  }

  Note.fromMap(Map map, this.id) {
    title = map[fieldTitle];
    descritpion = map[fieldDescription];
  }

  @override
  bool operator ==(other) {
    return other is Note &&
        other.title == title &&
        other.descritpion == descritpion &&
        other.id == id;
  }
}
