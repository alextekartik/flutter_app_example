import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tekartik_app_flutter_sqflite/sqflite.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_notepad_sqflite_common/notepad_sqflite_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  // For dev on windows, find the proper sqlite3.dll
  if (!kIsWeb) {
    sqfliteFfiInit();
  }
  var packageName = 'com.tekartik.sqflite.notepad';

  // sqflite_common_ffi on Android, iOS and macOS (in the sqflite plugin
  // databases folder), Linux and Windows (in
  // <userAppDataPath>/<packageName>/databases), sqflite_common_ffi_web on the
  // web.
  var databaseFactory = getDatabaseFactory(packageName: packageName);

  // Model, provider and pages shared with notepad_sqflite_ffi.
  await runNotepadApp(
    databaseFactory: databaseFactory,
    title: 'NotePad sqflite',
  );
}
