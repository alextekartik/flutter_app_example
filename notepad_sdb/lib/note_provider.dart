// ignore_for_file: prefer_const_declarations

import 'dart:async';

import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sdb_app/src/import.dart';

const String dbName = 'note_sdb.db';

const int kVersion1 = 1;

String fieldTitle = 'title';
String fieldDescription = 'description';

class MemoryNoteProvider extends NoteProvider {
  MemoryNoteProvider() : super(idbFactory: sdbFactoryMemory);
}

class NoteProvider {
  final SdbFactory idbFactory;
  late SdbDatabase db;

  static final noteStore = SdbStoreRef<int, SdbModel>('notes');
  static final String notesStoreName = 'notes';

  NoteProvider({required this.idbFactory});

  Future<int> getCount() async {
    var count = await noteStore.count(db);
    return count;
  }

  Future<Note?> getNote(int id) async {
    var map = await noteStore.record(id).getValue(db);
    if (map != null) {
      return Note.fromMap(map, id);
    }
    return null;
  }

  Future open() async {
    db = await idbFactory.openDatabase(
      dbName,
      version: kVersion1,
      onVersionChange: onUpgradeNeeded,
    );
  }

  void onUpgradeNeeded(SdbVersionChangeEvent event) {
    var db = event.db;
    db.createStore(noteStore, autoIncrement: true);
  }

  /// Add if id is null, update otherwise
  Future saveNote(Note note) async {
    if (note.id != null) {
      await noteStore.record(note.id!).put(db, note.toMap());
    } else {
      note.id = await noteStore.add(db, note.toMap());
    }
  }

  Future deleteNote(int? id) async {
    if (id != null) {
      await noteStore.record(id).delete(db);
    }
  }

  Future<List<Note>> getNotes() async {
    var maps = await noteStore.findRecords(db);
    var list =
        maps.map((map) {
          return Note.fromMap(map.value, map.key);
        }).toList();

    return list;
  }

  Future clearAllNotes() async {
    await noteStore.delete(db);
  }

  Future close() async {
    await db.close();
  }
}

class Note {
  int? id;
  String? title;
  String? description;

  Note({required this.title, required this.description, this.id});

  Map<String, String?> toMap() {
    var map = <String, String?>{
      fieldTitle: title,
      fieldDescription: description,
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
