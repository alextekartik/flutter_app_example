import 'package:process_run/shell_run.dart';
import 'test_all.dart' as test_all;

Future main() async {
  await run('''
  
  dartanalyzer --fatal-warnings --fatal-infos test tool
  dartfmt -n --set-exit-if-changed test tool
  pub run test
  
  ''');

  // await projects_generate.generateAll(force: true);
  await test_all.main();
}
