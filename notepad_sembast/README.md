# Sembast flutter notepad example

Note pad demo using [sembast](https://pub.dev/packages/sembast) based
persistency. [Online demo](https://alextekartik.github.io/flutter_app_example/notepad_sembast/).

Works on Flutter iOS/Android/Web/MacOS/Linux/Windows.

Simple sembast example:
* Usage of `StreamBuilder` with `Query.onSnapshots()`
* One database factory for every platform,
  [tekartik_app_flutter_sembast](https://github.com/tekartik/app_flutter_utils.dart/tree/master/app_sembast)
  `getDatabaseFactory(packageName: ...)` (`lib/app.dart`):

| Platform | Implementation | Database location |
|---|---|---|
| Android, iOS, macOS | sembast on SQLite (`sembast_sqflite`, ffi) | the sqflite plugin databases folder |
| Linux, Windows | sembast on SQLite (`sembast_sqflite`, ffi) | `<userAppDataPath>/com.tekartik.sembast.notepad/databases` (`~/.config/...`, `%APPDATA%\...`) |
| Web | `sembast_web` (IndexedDB, all tabs see the changes) | |

`lib/main_io.dart` is another entry point on plain sembast io files
(`createDatabaseFactoryIo`), in the documents directory on Android and in
`<application support directory>/databases` elsewhere:
`flutter run -t lib/main_io.dart`.

For new code on a local database prefer sdb: see
[notepad_sdb](../notepad_sdb/README.md).

## Setup

Project files are not checked in, simply run:

```bash
flutter create .
flutter run
```

### Example on windows

```bash
# (Optional) Delete/recreate existing project files
#            Might be needed when switching flutter branch
rmdir -Recurse -Force windows
flutter create --platforms windows .

# Run
flutter run -d windows
```
