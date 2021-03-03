import 'package:dev_test/package.dart';
import 'package:tekartik_build_utils/common_import.dart';

Future main() async {
  for (var dir in [
    '.',
    ...[
      'demoidb',
      'notepad',
      'demosembast',
      'notepad_sembast',
      'process_run_example',
    ].map((e) => join('..', e))
  ]) {
    await packageRunCi(dir);
  }
}
