import 'package:material_ui/material_ui.dart';
import 'package:tekartik_notepad_sqflite_common/src/app.dart';
import 'package:tekartik_notepad_sqflite_common/src/model/note.dart';

class EditNotePage extends StatefulWidget {
  /// null when adding a note
  final DbNote? initialNote;

  const EditNotePage({super.key, required this.initialNote});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

/// Trimmed text, null if empty.
String? _trimmedNonEmpty(String? text) {
  var trimmed = text?.trim();
  return (trimmed?.isEmpty ?? true) ? null : trimmed;
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleTextController;
  late final TextEditingController _contentTextController;

  int? get _noteId => widget.initialNote?.id.v;

  @override
  void initState() {
    super.initState();
    _titleTextController = TextEditingController(
      text: widget.initialNote?.title.v,
    );
    _contentTextController = TextEditingController(
      text: widget.initialNote?.content.v,
    );
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await noteProvider.saveNote(
        DbNote()
          ..id.v = _noteId
          ..title.v = _titleTextController.text
          ..content.v = _contentTextController.text
          ..date.v = DateTime.now().millisecondsSinceEpoch,
      );
      if (!mounted) {
        return;
      }
      var navigator = Navigator.of(context);
      navigator.pop();
      // Pop twice when editing
      if (_noteId != null) {
        navigator.pop();
      }
    }
  }

  bool _isTextDirty(String? newText, String? originalText) {
    return _trimmedNonEmpty(newText) != _trimmedNonEmpty(originalText);
  }

  bool get _isDirty =>
      _isTextDirty(_titleTextController.text, widget.initialNote?.title.v) ||
      _isTextDirty(_contentTextController.text, widget.initialNote?.content.v);

  Future<void> _delete() async {
    var confirmed =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete note?'),
              content: const Text('Tap \'YES\' to confirm note deletion.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('YES'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('NO'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (confirmed) {
      await noteProvider.deleteNote(widget.initialNote!.id.v);
      if (!mounted) {
        return;
      }
      // Pop twice to go back to the list
      var navigator = Navigator.of(context);
      navigator.pop();
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Always handled in onPopInvokedWithResult to check for changes
      canPop: false,
      onPopInvokedWithResult: (invoked, result) async {
        if (invoked) {
          return;
        }
        if (_isDirty) {
          var doDiscard = await _askDiscardChange(context) ?? false;
          if (!doDiscard) {
            return;
          }
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Note'),
          actions: <Widget>[
            if (_noteId != null)
              IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
            IconButton(icon: const Icon(Icons.save_alt), onPressed: save),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleTextController,
                      validator: (val) => _trimmedNonEmpty(val) != null
                          ? null
                          : 'Title must not be empty',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      controller: _contentTextController,
                      validator: (val) => _trimmedNonEmpty(val) != null
                          ? null
                          : 'Description must not be empty',
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _askDiscardChange(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard change?'),
          content: const Text(
            'Content has changed.\n\nTap \'CONTINUE\' to discard your changes.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('CONTINUE'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }
}
