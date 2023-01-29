// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tekartik_app_rx_utils/app_rx_utils.dart';
import 'package:tekartik_notepad_idb_app/note_provider.dart';

import 'note_edit.dart';

class NoteListPageBloc {
  final NoteProvider? noteProvider;

  NoteListPageBloc(this.noteProvider);
  final _subject = BehaviorSubject<List<Note>>();

  ValueStream<List<Note>> get notes => _subject;

  Future refresh() async {
    _subject.add(await noteProvider!.getNotes());
  }

  void dispose() {
    _subject.close();
  }
}

class NoteListPage extends StatefulWidget {
  final NoteProvider? noteProvider;

  const NoteListPage({Key? key, required this.noteProvider}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NoteListPageState();
  }
}

class NoteListPageState extends State<NoteListPage> {
  late NoteListPageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = NoteListPageBloc(widget.noteProvider);
    bloc.refresh();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: bloc.notes,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Notepad idb'),
          ),
          body: buildNotesList(snapshot),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                var result = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        NoteEditPage(noteProvider: widget.noteProvider!)));
                if (result == true) {
                  await bloc.refresh();
                }
              },
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
        await widget.noteProvider!.deleteNote(notes[index].id);
        await bloc.refresh();
      },
      child: ListTile(
        title: Text(notes[index].title!),
        subtitle: Text(notes[index].description!.length > 50
            ? notes[index].description!.substring(0, 50)
            : notes[index].description!),
        onTap: () async {
          var result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => NoteEditPage(
                  noteProvider: widget.noteProvider!, note: notes[index])));
          if (result == true) {
            await bloc.refresh();
          }
        },
      ),
    );
  }
}
