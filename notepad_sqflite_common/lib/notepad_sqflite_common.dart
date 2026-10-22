/// Common code of the sqflite notepad examples: model, provider and pages.
///
/// Each app chooses its database factory then calls [runNotepadApp].
library;

export 'src/app.dart' show NotepadApp, noteProvider, runNotepadApp;
export 'src/model/model_constant.dart' show dbName;
export 'src/model/note.dart' show DbNote;
export 'src/page/edit_page.dart' show EditNotePage;
export 'src/page/list_page.dart' show NoteListPage;
export 'src/page/note_page.dart' show NotePage;
export 'src/provider/note_provider.dart' show DbNoteProvider, DbNotes;
