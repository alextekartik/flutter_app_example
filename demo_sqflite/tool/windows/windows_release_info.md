# Example of building a windows release version

This is an example of building a windows release version of a flutter application that
uses `sqflite_common_ffi on windows.

It needs the proper steps:

Make sure you initialize sqflite_common_ffi properly:

```dart
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    // Use the ffi on windows
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
  }
  ...
  runApp(MyApp());
}
```

Once build for windows release, you need to copy the sqlite3.dll to the build folder. You can provide your own or use a prebuilt one
available here: https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll

Here are the steps you can run from the root of this [demo_sqflite](https://github.com/alextekartik/flutter_app_example/tree/master/demo_sqflite) project:
```
# Get the dependencies
dart pub get
# Create the windows project
dart run tool\windows\windows_01_create_project.dart
# Build the windows project
dart run tool\windows\windows_02_build.dart
# Copy the sqlite3.dll to the build folder
dart run tool\windows\windows_03_copy_sqlite3_dll.dart
# Run the application
dart run tool\windows\windows_04_run.dart
```
