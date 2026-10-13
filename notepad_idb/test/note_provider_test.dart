import 'package:flutter_test/flutter_test.dart';
import 'package:tekartik_notepad_idb_app/note_provider.dart';

void main() {
  testProvider(MemoryNoteProvider());
}

void testProvider(NoteProvider noteProvider) {
  setUp(() async {
    await noteProvider.open();
  });
  tearDown(() async {
    await noteProvider.close();
  });
  group('provider_generic', () {
    test('add', () async {
      await noteProvider.clearAllNotes();
      await noteProvider.saveNote(Note(title: 'test', description: 'desc'));
      expect(await noteProvider.getNotes(), hasLength(1));
    });
    test('getNotes newest first', () async {
      await noteProvider.clearAllNotes();
      await noteProvider.saveNote(Note(title: 'first', description: 'desc'));
      await noteProvider.saveNote(Note(title: 'second', description: 'desc'));
      var notes = await noteProvider.getNotes();
      expect(notes.map((note) => note.title), ['second', 'first']);
    });
    test('clearAllNotes', () async {
      await noteProvider.saveNote(Note(title: 'test', description: 'desc'));
      expect(await noteProvider.getCount(), greaterThan(0));
      await noteProvider.clearAllNotes();
      expect(await noteProvider.getCount(), 0);
      expect(await noteProvider.getNotes(), isEmpty);
    });
  });
}
