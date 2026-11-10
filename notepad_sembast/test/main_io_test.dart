import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:tekartik_notepad_sembast_app/main_io.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.rootPath);

  final String rootPath;

  @override
  Future<String?> getApplicationSupportPath() async =>
      join(rootPath, 'support');

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      join(rootPath, 'documents');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('io databases not in the current directory', () async {
    var rootPath = join(Directory.systemTemp.path, 'notepad_sembast_test');
    PathProviderPlatform.instance = _FakePathProvider(rootPath);
    var databasesPath = await ioDatabasesRootPath();
    // Not .dart_tool/... of the current directory, `/` in an iOS or macOS app.
    expect(isAbsolute(databasesPath), isTrue);
    expect(
      databasesPath,
      Platform.isAndroid
          ? join(rootPath, 'documents')
          : join(rootPath, 'support', 'databases'),
    );
  });
}
