// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tekartik_notepad_sqflite_app/provider/note_provider.dart';

void main() {
  var factory = databaseFactoryFfi;
  // factory.setLogLevel(sqfliteLogLevelVerbose);

  group('provider', () {
    test('save', () async {
      var provider = DbNoteProvider(factory);
      await provider.deleteDb();
      await provider.open();
      var first = await provider.onNotes().first;
      expect(first.first.title.v, 'Welcome to NotePad');
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
