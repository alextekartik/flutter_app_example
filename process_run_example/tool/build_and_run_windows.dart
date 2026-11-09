import 'dart:ffi';

import 'package:process_run/shell.dart';

Future main() async {
  // flutter build windows writes build/windows/<x64|arm64>/runner/Release.
  var arch = Abi.current() == Abi.windowsArm64 ? 'arm64' : 'x64';
  var shell = Shell();
  await shell.run('''
flutter build windows
build/windows/$arch/runner/Release/process_run_example
''');
}
