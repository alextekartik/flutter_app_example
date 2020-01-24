@TestOn('vm')
import 'package:test/test.dart';
import 'package:process_run/shell_run.dart';
import 'package:tekartik_build_utils/android/android_import.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';
import 'package:tekartik_build_utils/flutter/flutter.dart';

void main() {
  group('min_app', () {
    test('fs_generate', () async {
      var dirName =
          '.dart_tool/flutter_app_example_support/test/app/gen_demoidb';
      var src = '../demoidb';
      await fsGenerate(dir: dirName, src: src);
      var context = await flutterContext;
      if (context.supportsWeb) {
        await Shell(workingDirectory: dirName).run('flutter build web');
      }

      dirName = '.dart_tool/flutter_app_example_support/test/app/gen_notepad';
      src = '../notepad';
      await fsGenerate(dir: dirName, src: src);
      if (context.supportsWeb) {
        await Shell(workingDirectory: dirName).run('flutter build web');
      }
    });
  }, skip: !isFlutterSupported);
}
