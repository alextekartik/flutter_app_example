@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_ffi/sqflite_ffi.dart';
import 'package:tekartik_notepad_sqflite_common/notepad_sqflite_common.dart';

/// The shared provider on the sqflite_ffi factory of the app (the provider
/// itself is tested in notepad_sqflite_common).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  test('sqflite_ffi factory, relative name in the databases path', () async {
    var dir = await Directory.systemTemp.createTemp('notepad_sqflite_ffi_');
    try {
      var factory = sqfliteDatabaseFactoryFfi;
      await factory.setDatabasesPath(dir.path);
      var provider = DbNoteProvider(factory);
      await provider.deleteDb();
      await provider.open();
      var notes = await provider.onNotes().first;
      expect(notes.first.title.v, 'Welcome to NotePad');
      await provider.close();
      expect(File('${dir.path}/$dbName').existsSync(), isTrue);
    } finally {
      await dir.delete(recursive: true);
    }
  });
}
