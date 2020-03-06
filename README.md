# flutter_app_example

Flutter app examples

* [Notepad example](notepad_sembast/README.md) using sembast
* [Notepad example](notepad/README.md) using idb

## Manual setup

Since it is a pain to maintain projects for all target, only the minimum needed files
are checked in. You should be able to re-create the needed project files (gradle, workspace) using `flutter create .`
in each application folder.

### MacOS

Assuming you are on flutter dev channel

```bash
flutter create .
flutter run -d macos
```

### Web

Assuming you are on flutter web channel

```bash
flutter create .
flutter run -d chrome
```
