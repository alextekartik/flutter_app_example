# flutter_app_example

Flutter app examples

* [Notepad example](notepad_sembast/README.md) using sembast
* [Notepad example](notepad_idb/README.md) using idb
* [Notepad example](notepad_sdb/README.md) using sdb
* [Notepad example](notepad_sqflite/README.md) using sqflite
* [Notepad example](notepad_sqflite_ffi/README.md) using sqflite_ffi (no sqflite plugin)
  * both share their model, provider and pages in [notepad_sqflite_common](notepad_sqflite_common/README.md)
* Counter demos, the counter stored in a local database:
  [demo_sdb](demo_sdb/README.md) (sdb), [demo_idb](demo_idb/README.md) (idb),
  [demo_sembast](demo_sembast/README.md) (sembast),
  [demo_sqflite](demo_sqflite/README.md) (sqflite)

## Manual setup

Since it is a pain to maintain projects for all target, only the minimum needed files
are checked in. You should be able to re-create the needed project files (gradle, workspace) using `flutter create .`
in each application folder.

### MacOS

```bash
flutter create .
flutter run -d macos
```

### Linux

```bash
flutter create .
flutter run -d linux
```

### Windows

```bash
flutter create .
flutter run -d windows
```

### Web

```bash
flutter create .
flutter run -d chrome
```
