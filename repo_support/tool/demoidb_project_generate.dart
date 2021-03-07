import 'package:path/path.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';

String idbExampleDirName = join('..', 'demo_idb');

Future main() async {
  await generate();
}

Future generate({bool force}) async {
  await gitGenerate(
      dirName: idbExampleDirName,
      appName: 'tekartik_demoidb_app',
      force: force);
}
