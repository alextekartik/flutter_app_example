# demo_sdb

The Flutter counter app with the counter stored in a database with sdb, the
typed API of [idb_shim](https://pub.dev/packages/idb_shim), on every platform
through
[tekartik_app_flutter_idb](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_idb).
[Online demo](https://demo_sdb.surge.sh)

The counter is a record listened to with `onSnapshot`: on the web you can
open multiple tabs, the counter is synchronized.

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | SQLite (idb_sqflite, ffi) | the sqflite plugin databases folder |
| Linux, Windows | SQLite (idb_sqflite, ffi) | `<userAppDataPath>/com.tekartik.demosdb/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | the browser IndexedDB | |

`lib/main.dart` uses `getSdbFactory(packageName: ...)` (every platform),
`lib/main_web.dart` the web factory `sdbFactoryWeb` directly. The counter
code is in `lib/src/app.dart`.

## Setup

Project files are not checked in, see the build steps [here](../README.md#manual-setup):

```bash
flutter create .
flutter run
```

Web: `dart run tool/build_and_serve.dart` (wasm release build served
locally), `dart run tool/clean_build_and_run_web_interop_js.dart` (or
`..._wasm.dart`) for `lib/main_web.dart`.
