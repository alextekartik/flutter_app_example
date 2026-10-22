import 'package:flutter/widgets.dart';
import 'package:tekartik_notepad_sqflite_common/notepad_sqflite_common.dart';
import 'package:tekartik_notepad_sqflite_ffi_app/db/database_factory.dart';

Future<void> main() async {
  // Needed before path_provider calls.
  WidgetsFlutterBinding.ensureInitialized();
  // sqflite_ffi (databases in the application support directory) or
  // sqflite_common_ffi_web on the web, see database_factory.dart.
  var databaseFactory = await initNotepadDatabaseFactory();
  // Model, provider and pages shared with notepad_sqflite.
  await runNotepadApp(
    databaseFactory: databaseFactory,
    title: 'NotePad sqflite_ffi',
    color: const Color(0xFF009688),
  );
}
