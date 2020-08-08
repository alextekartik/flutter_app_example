import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();
  await shell.run('''
# flutter build windows
build/windows/runner/Debug/process_run_example
''');
}
