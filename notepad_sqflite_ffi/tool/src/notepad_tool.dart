import 'dart:io';

import 'package:dev_build/shell.dart';
import 'package:path/path.dart';

/// Pubspec name, also the executable name of the desktop builds.
const notepadAppName = 'tekartik_notepad_sqflite_ffi_app';

/// Organization used by `flutter create` (application id
/// `com.tekartik.tekartik_notepad_sqflite_ffi_app`).
const notepadOrg = 'com.tekartik';

/// The package folder (parent of `tool/`), whatever the current directory.
final notepadPackageDir = normalize(
  join(dirname(Platform.script.toFilePath()), '..'),
);

/// The host desktop platform: `linux`, `macos` or `windows`.
String get hostPlatform {
  if (Platform.isLinux) {
    return 'linux';
  } else if (Platform.isMacOS) {
    return 'macos';
  } else if (Platform.isWindows) {
    return 'windows';
  }
  throw UnsupportedError('No flutter desktop support on this host');
}

/// Shell in the package folder.
Shell notepadShell({bool interactive = false}) => Shell(
  workingDirectory: notepadPackageDir,
  stdin: interactive ? sharedStdIn : null,
);

/// Runs `flutter create` for [platform] when its folder is missing (platform
/// folders are not checked in).
Future<void> notepadCreatePlatform(String platform) async {
  if (Directory(join(notepadPackageDir, platform)).existsSync()) {
    return;
  }
  await notepadShell().run(
    'flutter create --org $notepadOrg --platforms $platform .',
  );
}

/// Runs `flutter run` with stdin forwarded (r: hot reload, R: hot restart,
/// q: quit).
Future<void> notepadFlutterRun(String arguments) async {
  try {
    await notepadShell(interactive: true).run('flutter run $arguments');
  } finally {
    // Otherwise the script never exits.
    await sharedStdIn.terminate();
  }
}
