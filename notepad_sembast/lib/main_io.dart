// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sembast_app/main.dart';
import 'package:tekartik_notepad_sembast_app/provider/note_provider.dart';

import 'app.dart';

/// Folder of the sembast io databases of this entry point: the documents
/// directory on Android, `<application support directory>/databases` on iOS,
/// macOS, Linux and Windows.
///
/// Never relative: the current directory is `/` in an iOS or macOS app (not
/// writable) and any launch folder on Linux and Windows.
Future<String> ioDatabasesRootPath() async {
  if (Platform.isAndroid) {
    return (await getApplicationDocumentsDirectory()).path;
  }
  return p.join((await getApplicationSupportDirectory()).path, 'databases');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use regular sembast io (but on the web).
  var factory = kIsWeb
      ? databaseFactoryWeb
      : createDatabaseFactoryIo(rootPath: await ioDatabasesRootPath());
  noteProvider = DbNoteProvider(factory);
  await noteProvider.ready;
  runApp(MyApp());
}
