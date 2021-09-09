import 'package:tekartik_notepad_sembast_app/db/db.dart';

class DbNote extends DbRecord {
  final title = CvField<String>('title');
  final content = CvField<String>('content');
  final date = CvField<int>('date');

  @override
  List<CvField> get fields => [title, content, date];
}
