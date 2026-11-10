import 'package:dev_build/build_support.dart';
import 'package:path/path.dart';
import 'package:process_run/process_run.dart';

var shell = Shell();
var windowsBuildPath = normalize(
  absolute(join('build', 'windows', 'x64', 'runner', 'Release')),
);

/// The release executable: `flutter create` names it after the pubspec name
/// (`tekartik_demo_sqflite.exe`), not after the folder.
Future<String> getWindowsExePath() async {
  var name = (await pathGetPubspecYamlMap('.'))['name'] as String;
  return join(windowsBuildPath, '$name.exe');
}
