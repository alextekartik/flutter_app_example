// ignore_for_file: directives_ordering, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tekartik_app_flutter_sqflite/sqflite.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sqflite_app/page/list_page.dart';
import 'package:tekartik_notepad_sqflite_app/provider/note_provider.dart';

late DbNoteProvider noteProvider;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  // For dev on windows, find the proper sqlite3.dll
  if (!kIsWeb) {
    sqfliteFfiInit();
  }
  var packageName = 'com.tekartik.sqflite.notepad';

  var databaseFactory = getDatabaseFactory(packageName: packageName);

  noteProvider = DbNoteProvider(databaseFactory);
  // devPrint('/notepad Starting');
  await noteProvider.ready;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotePad',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or simply save your changes to 'hot reload' in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: NoteListPage(),
    );
  }
}
