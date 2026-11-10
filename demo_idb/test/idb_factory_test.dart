import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:tekartik_demoidb_app/main.dart';

void main() {
  test('Linux/Windows databases in the user app data folder', () async {
    var appDataDir = await Directory.systemTemp.createTemp('demo_idb_test');
    // userAppDataPath override (process_run)
    platformEnvironment = {
      ...Platform.environment,
      'TEKARTIK_PROCESS_RUN_USER_APP_DATA_PATH': appDataDir.path,
    };
    try {
      // Not the ffi default relative to the current directory
      // (.dart_tool/sqflite_common_ffi/databases).
      expect(
        await appIdbFactory.getDatabaseFullPath(counterDbName),
        join(appDataDir.path, demoIdbPackageName, 'databases', counterDbName),
      );
    } finally {
      platformEnvironment = null;
      await appDataDir.delete(recursive: true);
    }
  }, skip: !(Platform.isLinux || Platform.isWindows));
}
