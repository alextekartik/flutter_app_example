@TestOn('vm')
library;

import 'package:test/test.dart';
import 'package:process_run/shell_run.dart';
import 'package:tekartik_build_utils/flutter/app/generate.dart';
import 'package:tekartik_build_utils/flutter/flutter.dart';

void main() {
  test('dummy', () {
    // just to make sure the test is running
  });
  group(
    'min_app',
    () {
      test('fs_generate', () async {
        var dirName =
            '.dart_tool/flutter_app_example_support/test/app/gen_demoidb';
        var src = '../demo_idb';
        await fsGenerate(dir: dirName, src: src);
        var context = await flutterContext;
        if (context.supportsWeb!) {
          await Shell(workingDirectory: dirName).run('''
              flutter packages get
              flutter build web
              ''');
        }

        dirName = '.dart_tool/flutter_app_example_support/test/app/gen_notepad';
        src = '../notepad_idb';
        await fsGenerate(dir: dirName, src: src);
        if (context.supportsWeb!) {
          await Shell(workingDirectory: dirName).run('flutter build web');
        }
      });
    },
    skip: !isFlutterSupported,
    // Allow 10 mn for web build (sdk download)
    timeout: Timeout(Duration(minutes: 10)),
  );
}
