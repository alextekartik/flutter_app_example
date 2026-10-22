/// Creates (once), builds and runs the notepad on the host desktop (Linux,
/// macOS or Windows).
///
/// ```bash
/// # flutter create (if needed), release build, then launch the built app
/// dart run tool/host_run.dart
/// # flutter create (if needed), then flutter run (r/R/q forwarded)
/// dart run tool/host_run.dart --debug
/// # flutter create (if needed) and release build only
/// dart run tool/host_run.dart --no-run
/// ```
library;

import 'dart:io';

import 'package:dev_build/shell.dart';
import 'package:path/path.dart';

import 'src/notepad_tool.dart';

Future<void> main(List<String> arguments) async {
  var debug = arguments.contains('--debug');
  var noRun = arguments.contains('--no-run');
  var platform = hostPlatform;

  await notepadCreatePlatform(platform);
  if (debug) {
    await notepadFlutterRun('-d $platform');
    return;
  }
  await notepadShell().run('flutter build $platform --release');
  if (noRun) {
    return;
  }
  var app = _releaseApp(platform);
  stdout.writeln('Running $app');
  if (platform == 'macos') {
    await notepadShell().run('open ${shellArgument(app)}');
  } else {
    await notepadShell().run(shellArgument(app));
  }
}

/// The built release executable (the `.app` bundle on macOS).
String _releaseApp(String platform) {
  var buildDir = join(notepadPackageDir, 'build', platform);
  switch (platform) {
    case 'macos':
      return join(
        buildDir,
        'Build',
        'Products',
        'Release',
        '$notepadAppName.app',
      );
    case 'linux':
      // build/linux/<x64|arm64>/release/bundle/<app>
      return join(_archDir(buildDir), 'release', 'bundle', notepadAppName);
    case 'windows':
      // build/windows/<x64|arm64>/runner/Release/<app>.exe
      return join(
        _archDir(buildDir),
        'runner',
        'Release',
        '$notepadAppName.exe',
      );
  }
  throw UnsupportedError(platform);
}

/// The architecture folder (x64 or arm64) of a desktop build.
String _archDir(String buildDir) {
  for (var arch in ['x64', 'arm64']) {
    var dir = join(buildDir, arch);
    if (Directory(dir).existsSync()) {
      return dir;
    }
  }
  throw StateError('No build found in $buildDir');
}
