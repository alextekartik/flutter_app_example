# Sqflite flutter notepad example

Note pad demo using sqflite based persistency ([Online web demo](https://notepad_sqflite.surge.sh))

Works on Flutter iOS/Android/MacOS/Linux/windows/web.

Simple sqflite example:
* Finding the proper sqflite database factory for the various platform:
  [tekartik_app_flutter_sqflite](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_sqflite)
  `getDatabaseFactory(packageName: ...)` (`lib/main.dart`)
* Open/read/write on the database

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | `sqflite_common_ffi` (SQLite bundled, not the `sqflite` plugin) | the sqflite plugin databases folder |
| Linux, Windows | `sqflite_common_ffi` | `<userAppDataPath>/com.tekartik.sqflite.notepad/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | `sqflite_common_ffi_web` | IndexedDB (setup needed, see below) |

The model, the provider and the pages are shared with
[notepad_sqflite_ffi](../notepad_sqflite_ffi/README.md) in
[notepad_sqflite_common](../notepad_sqflite_common/README.md); this app only
chooses the database factory (`lib/main.dart`).

## Setup

Project files are not checked in, simply run:

```bash
flutter create .
flutter run
```

Web: install the SQLite wasm binary and the sqflite shared worker
(`web/sqlite3.wasm`, `web/sqflite_sw.js`, not checked in) once, and again
after upgrading `sqflite_common_ffi_web` or `sqlite3`:

```bash
dart run tool/setup_web.dart
flutter run -d chrome
```
