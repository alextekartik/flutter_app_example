// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tekartik_app_flutter_idb/idb.dart';
import 'package:tekartik_notepad_app/main.dart';
import 'package:tekartik_notepad_app/note_provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      noteProvider: NoteProvider(idbFactory: idbFactoryMemory),
    ));
  });
}
