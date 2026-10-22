import 'package:material_ui/material_ui.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:tekartik_notepad_sqflite_common/src/page/list_page.dart';
import 'package:tekartik_notepad_sqflite_common/src/provider/note_provider.dart';

/// The notes of the app, set by [runNotepadApp].
late DbNoteProvider noteProvider;

/// Opens the notes database with [databaseFactory] and runs the app.
///
/// [databaseFactory] is the one of the platform, ready for the relative
/// database name `note.db` (databases path set if needed). [title] is shown
/// in the notes list app bar.
Future<void> runNotepadApp({
  required DatabaseFactory databaseFactory,
  required String title,
  Color color = Colors.blue,
}) async {
  noteProvider = DbNoteProvider(databaseFactory);
  await noteProvider.ready;
  runApp(NotepadApp(title: title, color: color));
}

/// The notepad app, [noteProvider] being ready.
class NotepadApp extends StatelessWidget {
  /// Title of the notes list.
  final String title;

  /// Theme seed color.
  final Color color;

  /// Notepad app.
  const NotepadApp({super.key, required this.title, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotePad',
      theme: ThemeData(colorSchemeSeed: color),
      home: NoteListPage(title: title),
    );
  }
}
