# Sqflite notepad common code

Model, provider and pages shared by the sqflite notepad examples:

- [notepad_sqflite](../notepad_sqflite/README.md): `sqflite` plugin on
  mobile, ffi on desktop, `sqflite_common_ffi_web` on the web (through
  `tekartik_app_flutter_sqflite`)
- [notepad_sqflite_ffi](../notepad_sqflite_ffi/README.md): `sqflite_ffi` on
  every native platform, `sqflite_common_ffi_web` on the web

It only depends on the sqflite API (`sqflite_common`): each app chooses its
`DatabaseFactory`, makes it ready for the relative database name `note.db`,
then runs the shared app:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var databaseFactory = ...; // the factory of the platform
  await runNotepadApp(databaseFactory: databaseFactory, title: 'NotePad');
}
```

## Tests

```bash
flutter test
```

The provider tests run on `sqflite_common_ffi`.
