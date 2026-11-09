import 'dart:ffi';

import 'package:process_run/shell.dart';

Future main() async {
  // flutter build linux writes build/linux/<x64|arm64>/release/bundle.
  var arch = Abi.current() == Abi.linuxArm64 ? 'arm64' : 'x64';
  var shell = Shell();
  await shell.run('''
flutter build linux
build/linux/$arch/release/bundle/process_run_example
''');
}
