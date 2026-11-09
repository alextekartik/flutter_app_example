# Notepad with sqflite_ffi

Notepad demo using [sqflite_ffi](https://pub.dev/packages/sqflite_ffi) on
Android, iOS, macOS, Linux and Windows, and
[sqflite_common_ffi_web](https://pub.dev/packages/sqflite_common_ffi_web) on
the web. It does not depend on the `sqflite` plugin: SQLite is bundled by
`package:sqlite3` (build hooks) on every native platform, so the same SQLite
version and features run everywhere.

The model, the provider and the pages are shared with
[notepad_sqflite](../notepad_sqflite/README.md) in
[notepad_sqflite_common](../notepad_sqflite_common/README.md); this app only
chooses and initializes the database factory.

## Database initialization

All of it is in [lib/db/database_factory.dart](lib/db/database_factory.dart),
called once in `main()`:

```dart
Future<void> main() async {
  // Needed before path_provider calls.
  WidgetsFlutterBinding.ensureInitialized();
  var databaseFactory = await initNotepadDatabaseFactory();
  await runNotepadApp(
    databaseFactory: databaseFactory,
    title: 'NotePad sqflite_ffi',
    color: const Color(0xFF009688),
  );
}
```

```dart
Future<DatabaseFactory> initNotepadDatabaseFactory() async {
  if (kIsWeb) {
    return databaseFactoryFfiWeb;
  }
  var factory = sqfliteDatabaseFactoryFfi;
  var supportDir = await getApplicationSupportDirectory();
  await factory.setDatabasesPath(join(supportDir.path, 'databases'));
  return factory;
}
```

The `sqflite_ffi` default databases path (`.dart_tool/sqflite_common_ffi/databases`
in the current directory) only suits `flutter test` and `flutter run` on
desktop from the project folder. On Android and iOS the current directory is
`/`, not writable. The app uses a `databases` folder in the application
support directory, with the same code on every platform:

| Platform | Database file |
|---|---|
| Android | `/data/user/0/com.tekartik.tekartik_notepad_sqflite_ffi_app/files/databases/note.db` |
| iOS | `<app container>/Library/Application Support/databases/note.db` |
| macOS | `~/Library/Containers/<bundle id>/Data/Library/Application Support/<bundle id>/databases/note.db` |
| Linux | `~/.local/share/com.tekartik.tekartik_notepad_sqflite_ffi_app/databases/note.db` |
| Windows | `%APPDATA%\com.tekartik\tekartik_notepad_sqflite_ffi_app\databases\note.db` |
| Web | IndexedDB of the site (shared worker, all tabs share the database) |

## Run on the host (Linux, macOS, Windows)

Platform folders are not checked in. The helper script creates the host
project once, makes a release build and launches it:

```bash
dart run tool/host_run.dart
```

- `--debug`: `flutter run -d <host>` instead (hot reload `r`, hot restart `R`, quit `q`)
- `--no-run`: create and build only

## Run on the web

```bash
dart run tool/web_run.dart
```

It creates the web project once, installs `web/sqlite3.wasm` and
`web/sqflite_sw.js` (`dart run sqflite_common_ffi_web:setup`), then runs
`flutter run -d chrome` (`--build` for a release build in `build/web`).
The setup only runs when `web/sqflite_sw.js` is missing. The worker holds the
code of `sqflite_common_ffi_web` and `sqflite_common_ffi`: after upgrading one
of them (or `sqlite3`), rebuild the binaries with
`dart run sqflite_common_ffi_web:setup --force`.

## Run on Android

```bash
# Once: create the android project
flutter create --org com.tekartik --platforms android .
# List the devices (emulator or phone with USB debugging)
flutter devices
# Debug run on a device
flutter run -d <device id>
# Or a release apk
flutter build apk --release
adb -s <device id> install -r build/app/outputs/flutter-apk/app-release.apk
adb -s <device id> shell monkey -p com.tekartik.tekartik_notepad_sqflite_ffi_app 1
```

Nothing Android specific is needed in the app: no sqflite plugin, SQLite is
the `libsqlite3.so` bundled by `package:sqlite3` for each ABI. To look at the
database of a debug build:

```bash
adb -s <device id> shell run-as com.tekartik.tekartik_notepad_sqflite_ffi_app ls files/databases
```

If the Android build complains about the Android Gradle Plugin version (newer
Flutter channels), update the `com.android.application` version in
`android/settings.gradle.kts` and the Gradle distribution in
`android/gradle/wrapper/gradle-wrapper.properties` to the ones of a freshly
created project.

## Tests

```bash
flutter test
```
