// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tekartik_common_utils/common_utils_import.dart';
import 'package:tekartik_notepad_sqflite_app/main.dart';
import 'package:tekartik_notepad_sqflite_app/model/model.dart';

class EditNotePage extends StatefulWidget {
  /// null when adding a note
  final DbNote? initialNote;

  const EditNotePage({Key? key, required this.initialNote}) : super(key: key);
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleTextController;
  TextEditingController? _contentTextController;

  int? get _noteId => widget.initialNote?.id.v;
  @override
  void initState() {
    super.initState();
    _titleTextController =
        TextEditingController(text: widget.initialNote?.title.v);
    _contentTextController =
        TextEditingController(text: widget.initialNote?.content.v);
  }

  Future save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await noteProvider.saveNote(DbNote()
        ..id.v = _noteId
        ..title.v = _titleTextController!.text
        ..content.v = _contentTextController!.text
        ..date.v = DateTime.now().millisecondsSinceEpoch);
      Navigator.pop(context);
      // Pop twice when editing
      if (_noteId != null) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var dirty = false;
        if (_titleTextController!.text != widget.initialNote?.title.v) {
          dirty = true;
        } else if (_contentTextController!.text !=
            widget.initialNote?.content.v) {
          dirty = true;
        }
        if (dirty) {
          return await (showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Discard change?'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Content has changed.'),
                            SizedBox(
                              height: 12,
                            ),
                            Text('Tap \'CONTINUE\' to discard your changes.'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('CONTINUE'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('CANCEL'),
                        ),
                      ],
                    );
                  })) ??
              false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Note',
          ),
          actions: <Widget>[
            if (_noteId != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  if (await showDialog<bool>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete note?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'Tap \'YES\' to confirm note deletion.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('YES'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('NO'),
                                ),
                              ],
                            );
                          }) ??
                      false) {
                    await noteProvider.deleteNote(widget.initialNote!.id.v);
                    // Pop twice to go back to the list
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
              ),
            // action button
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () {
                save();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        controller: _titleTextController,
                        validator: (val) =>
                            val!.isNotEmpty ? null : 'Title must not be empty',
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                        ),
                        controller: _contentTextController,
                        validator: (val) => val!.isNotEmpty
                            ? null
                            : 'Description must not be empty',
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      )
                    ]))
          ]),
        ),
      ),
    );
  }
}
