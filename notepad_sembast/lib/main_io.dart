// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sembast_app/main.dart';
import 'package:tekartik_notepad_sembast_app/provider/note_provider.dart';

import 'app.dart';

Future main() async {
  // Use regular sembast io (but on the web).
  var factory = kIsWeb
      ? databaseFactoryWeb
      : createDatabaseFactoryIo(
          rootPath: p.join(
              '.dart_tool', 'tekartik_notepad_sembast_app', 'databases'));
  noteProvider = DbNoteProvider(factory);
  await noteProvider.ready;
  runApp(MyApp());
}
