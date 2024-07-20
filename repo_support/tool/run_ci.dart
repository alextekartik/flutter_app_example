import 'package:dev_build/package.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future main() async {
  for (var dir in [
    '.',
    ...[
      'notepad_sqflite',
      'demo_idb',
      'notepad_idb',
      'demo_sembast',
      'notepad_sembast',
      'process_run_example',
    ].map((e) => join('..', e))
  ]) {
    await packageRunCi(dir);
  }
}
