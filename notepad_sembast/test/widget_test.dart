import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:tekartik_notepad_sembast_app/app.dart';
import 'package:tekartik_notepad_sembast_app/model/model.dart';
import 'package:tekartik_notepad_sembast_app/page/edit_page.dart';
import 'package:tekartik_notepad_sembast_app/page/note_page.dart';
import 'package:tekartik_notepad_sembast_app/provider/note_provider.dart';

/// Home page with a button pushing [page].
Widget _launcher(Widget Function() page) => MaterialApp(
  home: Builder(
    builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => page())),
        child: const Text('go'),
      ),
    ),
  ),
);

/// Let the in memory database and the ui (page transitions) run.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() {
    noteProvider = DbNoteProvider(databaseFactoryMemory);
  });

  Future<void> openDb(WidgetTester tester) async {
    var ready = () async {
      await noteProvider.deleteDb();
      await noteProvider.ready;
    }();
    await _settle(tester);
    await ready;
  }

  Future<T> dbAction<T>(
    WidgetTester tester,
    Future<T> Function() action,
  ) async {
    var future = action();
    await _settle(tester);
    return await future;
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await _settle(tester);
    await dbAction(tester, () => noteProvider.close());
  }

  testWidgets('blank title is rejected', (tester) async {
    await openDb(tester);
    await tester.pumpWidget(
      _launcher(() => const EditNotePage(initialNote: null)),
    );
    await tester.tap(find.text('go'));
    await _settle(tester);
    var fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '   ');
    await tester.enterText(fields.at(1), 'some content');
    await tester.tap(find.byIcon(Icons.save_alt));
    await _settle(tester);
    expect(find.text('Title must not be empty'), findsOneWidget);
    expect(find.byType(EditNotePage), findsOneWidget);
    var notes = await dbAction(tester, () => noteProvider.onNotes().first);
    expect(notes, hasLength(2));

    // Valid title, saved trimmed
    await tester.enterText(fields.at(0), ' title ');
    await tester.tap(find.byIcon(Icons.save_alt));
    await _settle(tester);
    expect(find.byType(EditNotePage), findsNothing);
    notes = await dbAction(tester, () => noteProvider.onNotes().first);
    expect(notes, hasLength(3));
    expect(notes.first.title.v, 'title');
    expect(notes.first.content.v, 'some content');
    await close(tester);
  });

  testWidgets('note without title', (tester) async {
    await openDb(tester);
    // As saved by a previous version
    var note = DbNote()
      ..content.v = 'some content'
      ..date.v = 3;
    await dbAction(tester, () => noteProvider.saveNote(note));
    await tester.pumpWidget(MaterialApp(home: NotePage(noteId: note.id!)));
    await _settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('some content'), findsOneWidget);
    await close(tester);
  });

  testWidgets('discard dialog after rebuild', (tester) async {
    await openDb(tester);
    await tester.pumpWidget(
      _launcher(() => const EditNotePage(initialNote: null)),
    );
    await tester.tap(find.text('go'));
    await _settle(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'dirty');
    // Rebuilt while dirty (parent rebuild, hot reload)
    tester.element(find.byType(EditNotePage)).markNeedsBuild();
    await tester.pump();

    NavigatorState navigator() => tester.state(find.byType(Navigator));
    navigator().maybePop().ignore();
    await _settle(tester);
    expect(find.text('Discard change?'), findsOneWidget);
    await tester.tap(find.text('CANCEL'));
    await _settle(tester);
    expect(find.byType(EditNotePage), findsOneWidget);

    navigator().maybePop().ignore();
    await _settle(tester);
    await tester.tap(find.text('CONTINUE'));
    await _settle(tester);
    expect(find.byType(EditNotePage), findsNothing);
    expect(find.text('go'), findsOneWidget);

    // Not dirty, no dialog
    await tester.tap(find.text('go'));
    await _settle(tester);
    navigator().maybePop().ignore();
    await _settle(tester);
    expect(find.text('Discard change?'), findsNothing);
    expect(find.byType(EditNotePage), findsNothing);
    await close(tester);
  });
}
