@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tekartik_notepad_sqflite_common/notepad_sqflite_common.dart';

void main() {
  sqfliteFfiInit();
  var factory = databaseFactoryFfi;
  late Directory dir;

  setUpAll(() async {
    // Like the app, relative database names resolve in the databases path.
    dir = await Directory.systemTemp.createTemp('notepad_sqflite_common_');
    await factory.setDatabasesPath(dir.path);
  });
  tearDownAll(() async {
    await dir.delete(recursive: true);
  });

  Future<DbNoteProvider> openNewProvider() async {
    var provider = DbNoteProvider(factory);
    await provider.deleteDb();
    await provider.open();
    return provider;
  }

  group('provider', () {
    test('save', () async {
      var provider = await openNewProvider();
      var note = DbNote()
        ..title.v = 'Test title'
        ..content.v = 'Test content'
        ..date.v = 3;
      await provider.saveNote(note);
      var id = note.id.v!;
      var notes = await provider.onNotes().first;
      expect(notes, hasLength(3));
      // Newest first
      expect(notes.first.id.v, id);
      expect(notes.first.title.v, 'Test title');
      expect((await provider.getNote(id))!.content.v, 'Test content');

      // Update
      await provider.saveNote(
        DbNote()
          ..id.v = id
          ..title.v = 'Updated title'
          ..content.v = 'Updated content'
          ..date.v = 4,
      );
      var updated = (await provider.getNote(id))!;
      expect(updated.title.v, 'Updated title');
      expect(updated.content.v, 'Updated content');

      await provider.deleteNote(id);
      expect(await provider.getNote(id), isNull);
      expect(await provider.onNotes().first, hasLength(2));
      await provider.close();
    });
    test('initial', () async {
      var provider = await openNewProvider();
      var first = await provider.onNotes().first;
      expect(first.length, 2);
      expect(first.first.title.v, 'Welcome to NotePad');
      await provider.close();
      // In the databases path set on the factory
      expect(File('${dir.path}/note.db').existsSync(), isTrue);
    });
    test('getListNotes', () async {
      var provider = await openNewProvider();
      List<String?> titles(List<DbNote> notes) =>
          notes.map((note) => note.title.v).toList();
      var newestFirst = ['Welcome to NotePad', 'Simple title'];
      expect(titles(await provider.getListNotes()), newestFirst);
      expect(
        titles(await provider.getListNotes(descending: false)),
        newestFirst.reversed,
      );
      await provider.close();
    });
  });
}
