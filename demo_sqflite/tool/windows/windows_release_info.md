# Example of building a windows release version

This is an example of building a windows release version of a flutter
application that uses `sqflite_common_ffi` on windows.

Initialize `sqflite_common_ffi` and set the databases path (the ffi default,
`.dart_tool/sqflite_common_ffi/databases`, is relative to the current
directory, which can be any folder, or a read-only one, for a released app),
as `initDatabaseFactory()` in [lib/main.dart](../../lib/main.dart) does:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    // Use the ffi on windows
    sqfliteFfiInit();
    var supportDir = await getApplicationSupportDirectory(); // path_provider
    await databaseFactoryFfi.setDatabasesPath(
      join(supportDir.path, 'databases'),
    );
    databaseFactoryOrNull = databaseFactoryFfi;
  }
  runApp(const MyApp());
}
```

`sqlite3.dll` does not need to be copied: since `sqlite3` 3.0.0 (used by
`sqflite_common_ffi` 2.4), the `sqlite3` package build hook compiles SQLite
and `flutter build windows` bundles the dll next to the executable. See the
[sqflite_common_ffi README](https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/README.md)
to use the system library or stay on `sqlite3` 2.x (which needs a
`sqlite3.dll` next to the executable).

Here are the steps you can run from the root of this
[demo_sqflite](https://github.com/alextekartik/flutter_app_example/tree/master/demo_sqflite)
project:

```
# Get the dependencies
dart pub get
# Create the windows project
dart run tool\windows\windows_01_create_project.dart
# Build the windows project
dart run tool\windows\windows_02_build.dart
# Run build\windows\x64\runner\Release\tekartik_demo_sqflite.exe from the
# home folder
dart run tool\windows\windows_03_run.dart
```
