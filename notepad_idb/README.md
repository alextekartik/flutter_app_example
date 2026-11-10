# Notepad idb

Notepad demo on the raw IndexedDB API of
[idb_shim](https://pub.dev/packages/idb_shim) (object store, cursors,
transactions), through
[tekartik_app_flutter_idb](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_idb).
[Online demo](https://alextekartik.github.io/flutter_app_example/notepad_idb/).
For new code prefer the typed sdb API: see
[notepad_sdb](../notepad_sdb/README.md), the same app on sdb.

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | SQLite (idb_sqflite, ffi) | the sqflite plugin databases folder |
| Linux, Windows | SQLite (idb_sqflite, ffi) | `<userAppDataPath>/com.tekartik.notepad_idb_app/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | the browser IndexedDB | |

The factory is chosen in `lib/main.dart` (`getIdbFactory(packageName: ...)`),
the database code is in `lib/note_provider.dart` (tested on the in memory
factory in `test/note_provider_test.dart`).

## Setup

Project files are not checked in, see the build steps [here](../README.md#manual-setup):

```bash
flutter create .
flutter run
```
