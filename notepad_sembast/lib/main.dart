// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sembast_app/page/list_page.dart';

import 'app.dart';

Future main() async {
  var packageName = 'com.tekartik.sembast.notepad';
  await init(packageName: packageName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
