import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idb_shim/idb_client.dart';
import 'package:idb_shim/idb_client_memory.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_common_utils/map_utils.dart';
import 'package:tekartik_common_utils/model/model.dart';

const String dbName = "note.db";

const int kVersion1 = 1;

String columnTitle = "title";
String columnDescription = "description";
String columnId = "_id";
String columnContent = "content";
String columnUpdated = "updated";

String tableNotes = "Notes";

class MemoryNoteProvider extends NoteProvider {
  MemoryNoteProvider() : super(idbFactory: idbMemoryFactory);
}

class NoteProvider {
  final IdbFactory idbFactory;
  Database db;

  static final String notesStoreName = 'notes';
  static final String updatedIndexName = 'updated';

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
    print('count $count');
    return count;
  }

  Future<Note> getNote(int id) async {
    var store = notesReadableTxn;
    Map<String, dynamic> map =
        asMap<String, dynamic>(await store?.getObject(id));
    // devPrint("getNote: ${map}");
    if (map != null) {
      return Note.fromMap(map)..id = id;
    }
    return null;
  }

  Future open() async {
    /*
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);

    String path = join(documentsDirectory.path, idbDbName);

     */
    db = await idbFactory.open(dbName,
        version: kVersion1, onUpgradeNeeded: onUpgradeNeeded);
  }

  void onUpgradeNeeded(VersionChangeEvent event) {
    var db = event.database;
    var store = db.createObjectStore(notesStoreName, autoIncrement: true);
    store.createIndex(updatedIndexName, 'updated');
  }

  Future saveNote(Note updatedNote) async {
    // devPrint('saveNote $updatedNote');
    var store = notesWritableTxn;
    if (updatedNote.id != null) {
      await store.put(updatedNote.toUpdateMap(), updatedNote.id);
    } else {
      updatedNote.id = await store.add(updatedNote.toUpdateMap()) as int;
    }
  }

  Future deleteNote(int id) async {
    if (id != null) {
      await notesWritableTxn.delete(id);
    }
  }

  Future<List<ListNote>> getListNotes({int offset, int limit}) async {
    // devPrint('getting $offset $limit');
    var list = <ListNote>[];
    var store = notesReadableTxn;
    var index = store.index(updatedIndexName);
    StreamSubscription subscription;
    subscription = index
        .openCursor(direction: idbDirectionPrev, autoAdvance: true)
        .listen((cursor) {
      try {
        if (offset != null) {
          if (offset-- > 0) {
            return;
          }
        }

        if (limit != null) {
          if (list.length >= limit) {
            subscription?.cancel();
            return;
          }
        }

        var map = asMap<String, dynamic>(cursor.value);

        if (map != null) {
          var note = cursorToListNote(cursor);
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

  Stream<ListNotes> onListNotes() {
    throw UnsupportedError('stream not supported for idb');
  }

  Future addTestNotes(int count) async {
    /*
    // find last id
    var lastId = await notesStore.findKey(db,
            finder: Finder(sortOrders: [SortOrder(Field.key, false)])) ??
        0;

     */
    var store = notesWritableTxn;
    int id;
    try {
      id = (await store.openKeyCursor(direction: idbDirectionPrev).first)
          ?.primaryKey as int;
    } catch (e) {
      print('error getting last id');
    }
    id ??= 0;

    for (int i = 0; i < count; i++) {
      var note = newNote(++id);
      await store.add(note.toUpdateMap());
    }

    return null;
  }

  Note newNote(int i) {
    var note = Note()
      ..title = 'Note $i'
      ..description = 'Description $i'
      ..content = "Content $i"
      ..updated = DateTime.now();
    return note;
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

ListNote cursorToListNote(
    CursorWithValue/*<int, Map<String, dynamic>>*/ cursor) {
  ListNote listNote;
  var snapshot = asMap(cursor.value);
  if (snapshot != null) {
    listNote = ListNote.fromMap(snapshot)..id = cursor.primaryKey as int;
  }
  return listNote;
}

class Note extends ListNote {
  String content;
  DateTime updated;

  Note();

  Note.fromMap(Map<String, dynamic> map, {int id})
      : super.fromMap(map, id: id) {
    content = map[columnContent] as String;
    int updatedMs = map[columnUpdated] as int;
    if (updatedMs != null) {
      updated = DateTime.fromMillisecondsSinceEpoch(updatedMs);
    }
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    var map = super.toUpdateMap();
    map[columnTitle] = title;
    map[columnDescription] = description;
    map[columnContent] = content;
    map[columnUpdated] = updated?.millisecondsSinceEpoch;

    return map;
  }
}

class ListNote {
  int id;
  String title;
  String description;

  ListNote();

  ListNote.fromMap(Map map, {int id}) {
    this.id = id ??= map[columnId] as int;
    title = map[columnTitle] as String;
    description = map[columnDescription] as String;
  }

  Map<String, dynamic> toUpdateMap() {
    var map = <String, dynamic>{};
    map[columnTitle] = title;
    map[columnDescription] = description;
    return map;
  }

  @override
  String toString() => "$id $title";
}

abstract class ListNotes implements List<ListNote> {}

abstract class ListNotesBase extends ListBase<ListNote> implements ListNotes {
  ModelList modelList;

  ListNotesBase(List list) {
    modelList = ModelList(list);
  }

  @override
  int get length => modelList.length;

  @override
  void operator []=(int index, ListNote value) {
    throw UnsupportedError('read-only');
  }

  @override
  set length(int newLength) => throw UnsupportedError('read-only');
}
