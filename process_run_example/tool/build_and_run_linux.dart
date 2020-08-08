import 'package:process_run/shell.dart';

Future main() async {
  var shell = Shell();
  await shell.run('''
flutter build linux
build/linux/release/bundle/process_run_example
''');
}
