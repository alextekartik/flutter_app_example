# demo_sembast

The Flutter counter app with the counter stored in a
[sembast](https://pub.dev/packages/sembast) database, on every platform
through
[tekartik_app_flutter_sembast](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_sembast).
[Online demo](https://alextekartik.github.io/flutter_app_example/demo_sembast)

The counter is a record listened to with `onSnapshot`: on the web you can
open multiple tabs, the counter is synchronized.

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | sembast on SQLite (sembast_sqflite, ffi) | the sqflite plugin databases folder |
| Linux, Windows | sembast on SQLite (sembast_sqflite, ffi) | `<userAppDataPath>/com.tekartik.demosembast/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | sembast_web (IndexedDB) | |

`lib/main.dart` uses `getDatabaseFactory(packageName: ...)` (every
platform), `lib/main_web.dart` the sembast_web factory directly. The counter
code is in `lib/src/app.dart`. For new code on a local database prefer sdb:
see [demo_sdb](../demo_sdb/README.md).

## Setup

Project files are not checked in, see the build steps [here](../README.md#manual-setup):

```bash
flutter create .
flutter run
```

Web: `dart run tool/build_and_run_web.dart` (release build served locally),
`dart run tool/clean_build_and_run_web_interop_js.dart` (or `..._wasm.dart`)
for `lib/main_web.dart`.
