import 'package:path/path.dart';
import 'package:process_run/process_run.dart';

import 'src/helper.dart';

Future<void> main() async {
  var exePath = join(windowsBuildPath, 'demo_sqflite.exe');

  /// Run from the home path to make sure it works from any directory
  var runPath = userHomePath;
  var shell = Shell().cd(runPath);
  await shell.run(shellArgument(exePath));
}
