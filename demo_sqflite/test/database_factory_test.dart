import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tekartik_demo_sqflite/main.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.applicationSupportPath);

  final String applicationSupportPath;

  @override
  Future<String?> getApplicationSupportPath() async => applicationSupportPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('ffi databases in the application support directory', () async {
    var supportPath = join(
      Directory.systemTemp.path,
      'demo_sqflite_test_support',
    );
    PathProviderPlatform.instance = _FakePathProvider(supportPath);
    await initDatabaseFactory();
    // Not the ffi default relative to the current directory.
    expect(
      await databaseFactory.getDatabasesPath(),
      join(supportPath, 'databases'),
    );
  }, skip: !(Platform.isLinux || Platform.isWindows));
}
