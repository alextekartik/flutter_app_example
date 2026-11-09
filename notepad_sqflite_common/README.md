# Sqflite notepad common code

Model, provider and pages shared by the sqflite notepad examples:

- [notepad_sqflite](../notepad_sqflite/README.md): `sqflite` plugin on
  mobile, ffi on desktop, `sqflite_common_ffi_web` on the web (through
  `tekartik_app_flutter_sqflite`)
- [notepad_sqflite_ffi](../notepad_sqflite_ffi/README.md): `sqflite_ffi` on
  every native platform, `sqflite_common_ffi_web` on the web

Not on pub.dev, a member of the flutter_app_example workspace.

It only depends on the sqflite API (`sqflite_common`): each app chooses its
`DatabaseFactory`, makes it ready for the relative database name `note.db`
(its databases path set where the default is not writable), then runs the
shared app. For example with `sqflite_common_ffi` on desktop:

```dart
import 'package:flutter/widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tekartik_notepad_sqflite_common/notepad_sqflite_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  await runNotepadApp(databaseFactory: databaseFactoryFfi, title: 'NotePad');
}
```

The notes alone (no UI) are in `DbNoteProvider(databaseFactory)`: `open()`,
`saveNote()`, `deleteNote()`, `getListNotes()`, and the `onNotes()` /
`onNote(id)` streams updated on every change.

## Tests

```bash
flutter test
```

The provider tests run on `sqflite_common_ffi`.
