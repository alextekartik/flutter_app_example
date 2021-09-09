import 'package:cv/cv.dart';
import 'package:tekartik_notepad_sqflite_app/db/db.dart';
import 'package:tekartik_notepad_sqflite_app/model/model_constant.dart';

class DbNote extends DbRecord {
  final title = CvField<String>(columnTitle);
  final content = CvField<String>(columnContent);
  final date = CvField<int>(columnUpdated);

  @override
  List<CvField> get fields => [id, title, content, date];
}
