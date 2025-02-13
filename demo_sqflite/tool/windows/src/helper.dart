import 'package:path/path.dart';
import 'package:process_run/process_run.dart';

var shell = Shell();
var windowsBuildPath = normalize(
  absolute(join('build', 'windows', 'x64', 'runner', 'Release')),
);
