import 'package:path/path.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';

String exampleDirName = join('..', 'demo_sembast');

Future main() async {
  await generate();
}

Future generate({bool force}) async {
  await gitGenerate(
      dirName: exampleDirName,
      appName: 'tekartik_demosembast_app',
      force: force);
}
