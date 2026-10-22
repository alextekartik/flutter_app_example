import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:tekartik_notepad_sqflite_common/src/app.dart';
import 'package:tekartik_notepad_sqflite_common/src/model/note.dart';
import 'package:tekartik_notepad_sqflite_common/src/page/edit_page.dart';
import 'package:tekartik_notepad_sqflite_common/src/page/note_page.dart';

class NoteListPage extends StatelessWidget {
  /// App bar title.
  final String title;

  const NoteListPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<List<DbNote>>(
        stream: noteProvider.onNotes(),
        builder: (context, snapshot) {
          var notes = snapshot.data;
          if (notes == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];
              var content = note.content.v;
              return ListTile(
                title: Text(note.title.v ?? ''),
                subtitle: (content?.isNotEmpty ?? false)
                    ? Text(LineSplitter.split(content!).first)
                    : null,
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => NotePage(noteId: note.id.v),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => const EditNotePage(initialNote: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
