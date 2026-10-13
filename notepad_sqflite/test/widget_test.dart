import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tekartik_notepad_sqflite_app/page/edit_page.dart';

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

void main() {
  testWidgets('discard dialog after rebuild', (tester) async {
    await tester.pumpWidget(
      _launcher(() => const EditNotePage(initialNote: null)),
    );
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'dirty');
    // Rebuilt while dirty (parent rebuild, hot reload)
    tester.element(find.byType(EditNotePage)).markNeedsBuild();
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
}
