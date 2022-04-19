// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sembast_app/provider/note_provider.dart';

import 'main.dart';
import 'src/import_sqflite.dart' as sqflite;

late DbNoteProvider noteProvider;

/// App initialization
Future<void> init({required String packageName}) async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  // For dev, find the proper sqlite3.dll
  if (!kIsWeb) {
    sqflite.sqfliteWindowsFfiInit();
  }
  var databaseFactory = getDatabaseFactory(packageName: packageName);

  noteProvider = DbNoteProvider(databaseFactory);
  // devPrint('/notepad Starting');
  await noteProvider.ready;
  runApp(MyApp());
}
