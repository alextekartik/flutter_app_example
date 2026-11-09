# `process_run` example

A Flutter desktop app running commands with
[process_run](https://pub.dev/packages/process_run) `Shell` and showing their
output (stdout, stderr in red) in a widget.

Tested on Linux, run sometimes on Windows and macOS. Desktop only:
`process_run` starts processes (`dart:io`), which the web cannot do.

What it shows:
* A `Shell(stdout: sink, stderr: sink)` whose output is turned into lines
  (`streamLines` in `lib/main.dart`) for a `StreamBuilder`.
* `shell.run(command)` from a menu or a typed command, `shell.kill()` (the
  delete button) to stop the running one.
* `which`, `userPaths`, `userEnvironment` and the dart/flutter executables
  (`@info`, `@path`, `@userEnv` menu entries).

This is not intended to be the perfect way of doing things...

## Setup

The platform folders are not checked in. The package belongs to the pub
workspace of the repository, run `flutter pub get` at its root once, then:

```bash
flutter create --platforms linux,macos,windows .
flutter run -d linux
```

`dart run tool/build_and_run_linux.dart` (or `tool/build_and_run_windows.dart`)
builds the release app and runs it.

### Mac support

In `macos/Runner/Release.entitlements` and `macos/Runner/DebugProfile.entitlements`,
turn the app sandbox off (a sandboxed app cannot start the processes):

```xml
<dict>
	<key>com.apple.security.app-sandbox</key>
	<false/>
</dict>
```
