# flutter_app_example

Flutter app examples

* [Notepad example](notepad_sembast/README.md) using sembast
* [Notepad example](notepad_idb/README.md) using idb
* [Notepad example](notepad_sqflite/README.md) using sqflite

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

### Linux

```bash
flutter create .
flutter run -d windows
```

### Web

```bash
flutter create .
flutter run -d chrome
```
