// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:tekartik_notepad_sembast_app/model/model.dart';
import 'package:tekartik_notepad_sembast_app/provider/note_provider.dart';

void main() {
  group('provider', () {
    test('save', () async {
      var provider = DbNoteProvider(databaseFactoryMemory);
      await provider.deleteDb();
      await provider.open();
      var note = DbNote()
        ..title.v = 'Test title'
        ..content.v = 'Test content'
        ..date.v = 3;
      await provider.saveNote(note);
      var id = note.id!;
      var notes = await provider.onNotes().first;
      expect(notes, hasLength(3));
      // Newest first
      expect(notes.first.id, id);
      expect(notes.first.title.v, 'Test title');
      expect((await provider.getNote(id))!.content.v, 'Test content');

      // Update
      await provider.saveNote(
        DbNote()
          ..id = id
          ..title.v = 'Updated title'
          ..content.v = 'Updated content'
          ..date.v = 4,
      );
      notes = await provider.onNotes().first;
      expect(notes, hasLength(3));
      var updated = (await provider.getNote(id))!;
      expect(updated.title.v, 'Updated title');
      expect(updated.content.v, 'Updated content');

      await provider.deleteNote(id);
      expect(await provider.getNote(id), isNull);
      expect(await provider.onNotes().first, hasLength(2));
      await provider.close();
    });
    test('initial', () async {
      var provider = DbNoteProvider(databaseFactoryMemory);
      await provider.deleteDb();
      await provider.open();
      var first = await provider.onNotes().first;
      expect(first.length, 2);
      expect(first.first.title.v, 'Welcome to NotePad');
      await provider.close();
    });
  });
}
