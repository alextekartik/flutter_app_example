# Notepad sdb

Notepad demo on sdb, the typed API of
[idb_shim](https://pub.dev/packages/idb_shim) (`SdbStoreRef`, `findRecords`,
no cursor nor transaction to manage), through
[tekartik_app_flutter_idb](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_idb).
[Online demo](https://notepad_sdb.surge.sh/). The same app on the raw
IndexedDB API: [notepad_idb](../notepad_idb/README.md).

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | SQLite (idb_sqflite, ffi) | the sqflite plugin databases folder |
| Linux, Windows | SQLite (idb_sqflite, ffi) | `<userAppDataPath>/com.tekartik.notepad_sdb_app/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | the browser IndexedDB | |

The factory is chosen in `lib/main.dart` (`getSdbFactory(packageName: ...)`),
the database code is in `lib/note_provider.dart` (tested on the in memory
factory in `test/note_provider_test.dart`).

## Setup

Project files are not checked in, see the build steps [here](../README.md#manual-setup):

```bash
flutter create .
flutter run
```

Web: `dart run tool/build_and_serve.dart` (wasm release build served
locally).
