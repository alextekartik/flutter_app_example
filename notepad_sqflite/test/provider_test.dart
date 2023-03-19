// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tekartik_notepad_sqflite_app/provider/note_provider.dart';
import 'package:tekartik_notepad_sqflite_app/src/import.dart';

void main() {
  var factory = databaseFactoryFfi;
  if (!kIsWeb) {
    sqfliteFfiInit();
  }
  // factory.setLogLevel(sqfliteLogLevelVerbose);

  group('provider', () {
    test('save', () async {
      var provider = DbNoteProvider(factory);
      await provider.deleteDb();
      await provider.open();
      var first = await provider.onNotes().first;
      expect(first.first!.title.v, 'Welcome to NotePad');
      await provider.close();
    });
    test('initial', () async {
      var provider = DbNoteProvider(factory);
      await provider.deleteDb();
      await provider.open();
      var first = await provider.onNotes().first;
      expect(first.length, 2);
      await provider.close();
    });
  });
}
