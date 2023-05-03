// ignore_for_file: prefer_const_constructors, directives_ordering

import 'package:flutter/material.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sqflite_app/main.dart';
import 'package:tekartik_notepad_sqflite_app/model/model.dart';
import 'package:tekartik_notepad_sqflite_app/page/edit_page.dart';
import 'package:tekartik_notepad_sqflite_app/page/note_page.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'NotePad sqflite',
      )),
      body: StreamBuilder<List<DbNote?>>(
        stream: noteProvider.onNotes(),
        builder: (context, snapshot) {
          var notes = snapshot.data;
          if (notes == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                var note = notes[index]!;
                return ListTile(
                  title: Text(note.title.v ?? ''),
                  subtitle: note.content.v?.isNotEmpty ?? false
                      ? Text(LineSplitter.split(note.content.v!).first)
                      : null,
                  onTap: () {
                    Navigator.of(context)
                        .push<void>(MaterialPageRoute(builder: (context) {
                      return NotePage(
                        noteId: note.id.v,
                      );
                    }));
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push<void>(MaterialPageRoute(builder: (context) {
            return EditNotePage(
              initialNote: null,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
