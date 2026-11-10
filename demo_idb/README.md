# demo_idb

The Flutter counter app with the counter stored in an IndexedDB style
database ([idb_shim](https://pub.dev/packages/idb_shim) raw API: object
store, transactions), on every platform through
[tekartik_app_flutter_idb](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_idb).
[Online demo](https://alextekartik.github.io/flutter_app_example/demo_idb)

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | SQLite (idb_sqflite, ffi) | the sqflite plugin databases folder |
| Linux, Windows | SQLite (idb_sqflite, ffi) | `<userAppDataPath>/com.tekartik.demoidb/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | the browser IndexedDB | |

The factory is `appIdbFactory` (`lib/main.dart`):
`getIdbFactory(packageName: ...)`, not the plain `idbFactory` getter, whose
Linux/Windows databases would be in `.dart_tool` of the current directory.
For new code prefer the typed sdb API: see [demo_sdb](../demo_sdb/README.md).

## Setup

Project files are not checked in, see the build steps [here](../README.md#manual-setup):

```bash
flutter create .
flutter run
```

Web: `dart run tool/run_web.dart`. `lib/main_web_interop.dart` is a web only
entry point (native IndexedDB, it also prints how values convert between
Dart and JavaScript): `dart run tool/run_web_interop.dart`, or a release
build served locally with `dart run tool/clean_build_and_run_interop_js.dart`
(`..._wasm.dart` for wasm).
