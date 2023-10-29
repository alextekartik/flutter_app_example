import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_idb/idb.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_notepad_idb_app/note_provider.dart';
import 'package:tekartik_notepad_idb_app/page/note_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  // print('factory: ${getIdbFactory(packageName: 'com.tekartik.notepad_idb_app')}');
  var noteProvider = NoteProvider(
      idbFactory: getIdbFactory(packageName: 'com.tekartik.notepad_idb_app'));
  await noteProvider.open();
  runApp(MyApp(noteProvider: noteProvider));
}

class MyApp extends StatelessWidget {
  final NoteProvider? noteProvider;

  const MyApp({super.key, this.noteProvider});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Notepad Idb',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NoteListPage(
          noteProvider: noteProvider,
        ));
  }
}
