import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

import '../tool/windows/src/helper.dart';

void main() {
  test('windows exe name', () async {
    // flutter create names the binary after the pubspec name.
    expect(basename(await getWindowsExePath()), 'tekartik_demo_sqflite.exe');
  });
}
