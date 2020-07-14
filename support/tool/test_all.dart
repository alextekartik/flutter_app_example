import 'package:process_run/shell.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future main() async {
  var shell = Shell();

  for (var dir in [
    'demoidb',
    'notepad',
    'demosembast',
    'notepad_sembast',
    'process_run_example',
  ]) {
    shell = shell.pushd(join('..', dir));
    await shell.run('''

flutter packages get

    ''');
    if (File(join(dir, 'travis.dart')).existsSync()) {
      await shell.run('''

dart tool/travis.dart

    ''');
    } else {
      await shell.run('''

flutter analyze
flutter test

    ''');
    }
    shell = shell.popd();
  }
}
