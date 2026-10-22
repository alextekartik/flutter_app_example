/// Database factory initialization, one place for all platforms.
///
/// The app does not use the `sqflite` plugin:
///
/// | Platform | Implementation | Database location |
/// |---|---|---|
/// | Android | `sqflite_ffi` | `/data/user/0/<application id>/files/databases` |
/// | iOS | `sqflite_ffi` | `<app container>/Library/Application Support/databases` |
/// | macOS | `sqflite_ffi` | `~/Library/Containers/<bundle id>/Data/Library/Application Support/<bundle id>/databases` |
/// | Linux | `sqflite_ffi` | `~/.local/share/<application id>/databases` |
/// | Windows | `sqflite_ffi` | `%APPDATA%\<company>\<product>\databases` |
/// | Web | `sqflite_common_ffi_web` | IndexedDB of the site origin |
///
/// - `sqflite_ffi` uses SQLite bundled by `package:sqlite3` (build hooks,
///   nothing to install) and runs it in a background isolate shared by all
///   the Flutter isolates of the app.
/// - Its default databases path, `.dart_tool/sqflite_common_ffi/databases`
///   in the current directory, is fine for `flutter test` but not for an
///   app: the current directory is `/` (read-only) on Android and iOS, and an
///   installed desktop app can be started from anywhere. The databases path
///   is set to a `databases` folder in the application support directory
///   (`path_provider`), the same code on every platform: a private, writable
///   folder that the user does not see.
/// - On the web, `sqflite_common_ffi_web` runs SQLite (wasm) in a shared
///   worker persisting to IndexedDB, so several tabs share the same
///   database. It needs `web/sqlite3.wasm` and `web/sqflite_sw.js`, created
///   by `dart run sqflite_common_ffi_web:setup` (see `tool/web_run.dart`).
library;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_ffi/sqflite_ffi.dart';

/// The databases path of the app on Android, iOS, macOS, Linux and Windows:
/// a `databases` folder in the application support directory.
Future<String> notepadDatabasesPath() async {
  var supportDir = await getApplicationSupportDirectory();
  return join(supportDir.path, 'databases');
}

/// Returns the database factory to use on the current platform, ready for
/// relative database names (`note.db`).
///
/// Call it once in `main()` after `WidgetsFlutterBinding.ensureInitialized()`
/// (`path_provider` uses platform channels).
Future<DatabaseFactory> initNotepadDatabaseFactory() async {
  if (kIsWeb) {
    // Database names are keys in IndexedDB, there is no path to set.
    return databaseFactoryFfiWeb;
  }
  // Also registered as the default `databaseFactory` by the sqflite_ffi
  // plugin, only used explicitly here.
  var factory = sqfliteDatabaseFactoryFfi;
  // Relative database names now resolve in the application support
  // directory. The path is stored in this factory (main isolate only): give
  // full paths to other isolates (`join(await factory.getDatabasesPath(), name)`).
  await factory.setDatabasesPath(await notepadDatabasesPath());
  return factory;
}
