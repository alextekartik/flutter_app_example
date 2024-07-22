import 'package:flutter/material.dart';
import 'package:idb_shim/sdb.dart';
import 'package:tekartik_app_flutter_idb/idb.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_notepad_sdb_app/note_provider.dart';
import 'package:tekartik_notepad_sdb_app/page/note_list.dart';
import 'package:tekartik_web_splash/web_splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  webSplashReady();
  platformInit();
  // print('factory: ${getIdbFactory(packageName: 'com.tekartik.notepad_sdb_app')}');
  var noteProvider = NoteProvider(
      idbFactory: sdbFactoryFromIdb(
          getIdbFactory(packageName: 'com.tekartik.notepad_sdb_app')));
  await noteProvider.open();
  webSplashHide();
  runApp(MyApp(noteProvider: noteProvider));
}

class MyApp extends StatelessWidget {
  final NoteProvider? noteProvider;

  const MyApp({super.key, this.noteProvider});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Notepad Sdb',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: NoteListPage(
          noteProvider: noteProvider,
        ));
  }
}
