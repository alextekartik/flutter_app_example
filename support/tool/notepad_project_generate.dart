import 'package:path/path.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';

String notepadAppDirName = join('..', 'notepad');
Future main() async {
  await gitGenerate(
      dirName: notepadAppDirName, appName: 'tekartik_notepad_app');
}
