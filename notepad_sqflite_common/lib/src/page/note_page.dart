import 'package:material_ui/material_ui.dart';
import 'package:tekartik_notepad_sqflite_common/src/app.dart';
import 'package:tekartik_notepad_sqflite_common/src/model/note.dart';
import 'package:tekartik_notepad_sqflite_common/src/page/edit_page.dart';

class NotePage extends StatelessWidget {
  final int? noteId;

  const NotePage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DbNote?>(
      stream: noteProvider.onNote(noteId),
      builder: (context, snapshot) {
        var note = snapshot.data;

        void edit() {
          if (note != null) {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => EditNotePage(initialNote: note),
              ),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Note'),
            actions: <Widget>[
              if (note != null)
                IconButton(icon: const Icon(Icons.edit), onPressed: edit),
            ],
          ),
          body: (note == null)
              ? const Center(child: CircularProgressIndicator())
              : GestureDetector(
                  onTap: edit,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          note.title.v ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(title: Text(note.content.v ?? '')),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
