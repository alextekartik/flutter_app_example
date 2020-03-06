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
        ..title.v = 'my_title'
        ..content.v = 'my content'
        ..date.v = DateTime.now().millisecondsSinceEpoch;
      await provider.saveNote(note);
      var first = await provider.onNotes().first;
      expect(first.first.title.v, 'my_title');
      await provider.close();
    });
    test('initial', () async {
      var provider = DbNoteProvider(databaseFactoryMemory);
      await provider.deleteDb();
      await provider.open();
      var first = await provider.onNotes().first;
      expect(first.length, 2);
      await provider.close();
    });
  });
}
