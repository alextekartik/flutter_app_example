import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/windows/sqflite_ffi_setup.dart';

import 'src/helper.dart';

Future<void> main() async {
  var sqlite3Path = findWindowsSqlite3DllPath()!;
  await File(sqlite3Path).copy(join(windowsBuildPath, basename(sqlite3Path)));
}
