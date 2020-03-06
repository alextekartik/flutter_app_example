import 'package:flutter/material.dart';
import 'package:tekartik_notepad_app/note_provider.dart';

import 'note_edit.dart';

class NoteListPage extends StatefulWidget {
  final NoteProvider noteProvider;

  const NoteListPage({Key key, @required this.noteProvider}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NoteListPageState();
  }
}

class NoteListPageState extends State<NoteListPage> {
  NoteProvider get noteProvider => widget.noteProvider;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Note>>(
      future: widget.noteProvider.getNotes(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Notepad'),
          ),
          body: buildNotesList(snapshot),
          floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      NoteEditPage(noteProvider: widget.noteProvider))),
              child: Icon(Icons.add)),
        );
      },
    );
  }

  Widget buildNotesList(AsyncSnapshot<List<Note>> snapshot) {
    var notes = snapshot.data;
    if (notes != null) {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _createItem(notes, index),
          itemCount: notes.length);
    }
    // print('snapshot ${snapshot.connectionState} ${snapshot.data}');
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        break;
      default:
        if (snapshot.hasError) {
          return Text('Unexected error occurs: ${snapshot.error}');
        }
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _createItem(List<Note> notes, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        await noteProvider.deleteNote(notes[index].id);
      },
      child: ListTile(
        title: Text(notes[index].title),
        subtitle: Text(notes[index].description.length > 50
            ? notes[index].description.substring(0, 50)
            : notes[index].description),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => NoteEditPage(
                  noteProvider: noteProvider, note: notes[index])));
        },
      ),
    );
  }
}
