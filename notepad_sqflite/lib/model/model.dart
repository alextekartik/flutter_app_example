import 'package:tekartik_notepad_sqflite_app/db/db.dart';
import 'package:tekartik_notepad_sqflite_app/model/model_constant.dart';

class DbNote extends DbRecord {
  final title = stringField(columnTitle);
  final content = stringField(columnContent);
  final date = intField(columnUpdated);

  @override
  List<Field> get fields => [id, title, content, date];
}
