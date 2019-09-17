import 'package:flutter_test/flutter_test.dart';
import 'package:tekartik_notepad_app/note_provider.dart';

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
      await noteProvider.saveNote(Note(title: 'test', descritpion: 'desc'));
      expect(await noteProvider.getNotes(), hasLength(1));
    });
  });
}
