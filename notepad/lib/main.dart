import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_idb/idb.dart';
import 'package:tekartik_notepad_app/note_provider.dart';
import 'package:tekartik_notepad_app/page/note_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var noteProvider = NoteProvider(idbFactory: idbFactory);
  await noteProvider.open();
  runApp(MyApp(noteProvider: noteProvider));
}

class MyApp extends StatelessWidget {
  final NoteProvider noteProvider;

  const MyApp({Key key, this.noteProvider}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NoteListPage(
          noteProvider: noteProvider,
        ));
  }
}
