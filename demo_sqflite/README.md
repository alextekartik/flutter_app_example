# tekartik_demo_sqflite

Counter app using sqflite: the counter is a row of a SQLite table, incremented
in a transaction (`lib/counter_database.dart`).

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | `sqflite` plugin | the plugin databases path |
| Linux, Windows | `sqflite_common_ffi` | `<application support directory>/databases` |
| Web | `sqflite_common_ffi_web` | IndexedDB (setup needed) |

The implementation is chosen in `initDatabaseFactory()` (`lib/main.dart`).

## Online demo

https://tk-demo-sqflite.web.app

## Setup

Project files are not checked in, simply run:

```bash
flutter create .
flutter run
```

Web: create the web project and install the SQLite wasm binary and the
sqflite shared worker (`web/sqlite3.wasm`, `web/sqflite_sw.js`):

```bash
dart run tool/web/setup_sqflite_web.dart
flutter run -d chrome
```

Windows release build: see
[tool/windows/windows_release_info.md](tool/windows/windows_release_info.md).
