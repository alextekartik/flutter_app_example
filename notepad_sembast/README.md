# Sembast flutter notepad example

Note pad demo using sembast based persistency. [Online demo](https://alextekartik.github.io/flutter_app_example/notepad_sembast/).

Works on Flutter iOS/Android/Web/MacOS/Linux/windows.

Simple sembast example:
* Usage of `StreamBuilder` with `Query.onSnapshots()`
* Works on the web using `sembast_web`
* Works on flutter mobile using `sembast_sqflite`
* Works on flutter desktop using `sembast_sqflite` and `sqflite_common_ffi`

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