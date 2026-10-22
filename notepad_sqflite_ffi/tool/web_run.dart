/// Creates (once) the web project, installs the sqflite web binaries and runs
/// the notepad in Chrome.
///
/// ```bash
/// # flutter create (if needed), sqflite_common_ffi_web setup, flutter run -d chrome
/// dart run tool/web_run.dart
/// # same with a release build in build/web instead of running
/// dart run tool/web_run.dart --build
/// ```
library;

import 'dart:io';

import 'package:path/path.dart';

import 'src/notepad_tool.dart';

Future<void> main(List<String> arguments) async {
  var build = arguments.contains('--build');

  await notepadCreatePlatform('web');
  // web/sqlite3.wasm and web/sqflite_sw.js (shared worker running SQLite).
  if (!File(join(notepadPackageDir, 'web', 'sqflite_sw.js')).existsSync()) {
    await notepadShell().run('dart run sqflite_common_ffi_web:setup');
  }
  if (build) {
    await notepadShell().run('flutter build web --release');
    return;
  }
  await notepadFlutterRun('-d chrome');
}
