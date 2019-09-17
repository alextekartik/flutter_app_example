import 'package:flutter/material.dart';
import 'package:tekartik_notepad_app/note_provider.dart';

class NoteEditPage extends StatefulWidget {
  final NoteProvider noteProvider;
  final Note note;

  /// If [note] is null, it is a new note
  NoteEditPage({this.note, this.noteProvider});

  @override
  NoteEditPageState createState() {
    return NoteEditPageState();
  }
}

class NoteEditPageState extends State<NoteEditPage> {
  NoteProvider get noteProvider => widget.noteProvider;
  Note get note => widget.note;

  final _formKey = GlobalKey<FormState>();

  String _title;
  String _description;

  Future _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await noteProvider.saveNote(
          Note(title: _title, descritpion: _description, id: note?.id));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit notes data"),
      ),
      body: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: InputBorder.none,
                        ),
                        key: Key("title"),
                        initialValue: note?.title,
                        validator: (val) =>
                            val.isNotEmpty ? null : "Title must not be empty",
                        onSaved: (val) => _title = val,
                      ),
                    ),
                    Container(
                        child: Divider(
                      color: Colors.black,
                    )),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: InputBorder.none,
                      ),
                      key: Key("description"),
                      initialValue: note?.descritpion,
                      validator: (val) => val.isNotEmpty
                          ? null
                          : "Description must not be empty",
                      onSaved: (val) => _description = val,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    )
                  ]))),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _submit(), child: Icon(Icons.check)),
    );
  }
}
