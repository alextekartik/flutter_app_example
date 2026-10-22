import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tekartik_notepad_sqflite_common/notepad_sqflite_common.dart';

/// Home page with a button pushing [page].
Widget _launcher(Widget Function() page) => MaterialApp(
  home: Builder(
    builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () =>
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (_) => page())),
        child: const Text('go'),
      ),
    ),
  ),
);

void main() {
  testWidgets('discard dialog', (tester) async {
    await tester.pumpWidget(
      _launcher(() => const EditNotePage(initialNote: null)),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'dirty');
    await tester.pump();

    NavigatorState navigator() => tester.state(find.byType(Navigator));
    navigator().maybePop().ignore();
    await tester.pumpAndSettle();
    expect(find.text('Discard change?'), findsOneWidget);
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();
    expect(find.byType(EditNotePage), findsOneWidget);

    navigator().maybePop().ignore();
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    expect(find.byType(EditNotePage), findsNothing);

    // Not dirty, no dialog
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    navigator().maybePop().ignore();
    await tester.pumpAndSettle();
    expect(find.text('Discard change?'), findsNothing);
    expect(find.byType(EditNotePage), findsNothing);
  });
  testWidgets('blank title rejected', (tester) async {
    await tester.pumpWidget(
      _launcher(() => const EditNotePage(initialNote: null)),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '   ');
    await tester.enterText(find.byType(TextFormField).at(1), 'content');
    await tester.tap(find.byIcon(Icons.save_alt));
    await tester.pumpAndSettle();
    expect(find.text('Title must not be empty'), findsOneWidget);
    expect(find.byType(EditNotePage), findsOneWidget);
  });
}
