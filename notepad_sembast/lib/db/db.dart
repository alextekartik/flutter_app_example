import 'package:tekartik_notepad_sembast_app/utils/utils.dart';
import 'package:tekartik_common_utils/model/model.dart';

abstract class DbRecord {
  /// to override something like [name, description]
  List<Field> get fields;

  // Only created if necessary
  Map<String, Field> _fieldMap;

  Field getField(String name) {
    _fieldMap ??=
        Map.fromEntries(fields.map((field) => MapEntry(field.name, field)));
    return _fieldMap[name];
  }

  final id = Field<int>('id');

  Field<T> field<T>(String name) {
    return Field<T>(name);
  }

  Model toMap({List<Field> fields}) {
    fields ??= this.fields;
    var model = Model();
    for (var field in fields) {
      model.setValue(field.name, field.v, presentIfNull: field.hasValue);
    }
    return model;
  }

  void fromMap(Map map, {List<Field> fields, int id}) {
    this.id.v = id;
    fields ??= this.fields;
    var model = Model(map);
    for (var field in fields) {
      var entry = model.getModelEntry(field.name);
      if (entry != null) {
        field.v = entry.value;
      }
    }
  }

  void fromRecord(DbRecord record) {
    for (var field in fields) {
      var recordField = record.getField(field.name);
      if (recordField?.hasValue == true) {
        field.fromField(recordField);
      }
    }
  }

  @override
  String toString() => logTruncate(toMap(fields: [
        ...[id],
        ...fields
      ]).toString());
}

class Column<T> {
  final String name;

  Column(this.name);
}

class Field<T> extends Column<T> {
  T _value;

  /// The value
  T get v => _value;

  /// The key
  String get k => name;

  bool get isNull => _value == null;

  set v(T value) {
    _hasValue = true;
    _value = value;
  }

  void removeValue() {
    _value = null;
    _hasValue = false;
  }

  void setValue(T value, {bool presentIfNull}) {
    if (value == null) {
      if (presentIfNull != true) {
        this.v = value;
      } else {
        removeValue();
      }
    } else {
      this.v = value;
    }
  }

  bool _hasValue = false;

  bool get hasValue => _hasValue;

  Field(String name) : super(name);

  void fromField(Field<T> field) {
    setValue(field.v, presentIfNull: field.hasValue);
  }

  @override
  String toString() => '$name: $v${(v == null && hasValue) ? ' (set)' : ''}';
}

Field<int> intField(String name) => Field<int>(name);

Field<String> stringField(String name) => Field<String>(name);
