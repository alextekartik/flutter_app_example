import 'package:flutter/foundation.dart';
import 'package:tekartik_app_flutter_sqflite/sqflite.dart';

void appInit() {
  // For dev on windows, find the proper sqlite3.dll
  if (!kIsWeb) {
    sqfliteWindowsFfiInit();
  }
}
