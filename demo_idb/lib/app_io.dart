import 'package:flutter/foundation.dart';
import 'package:tekartik_demoidb_app/src/import.dart';

void appInit() {
  // For dev on windows, find the proper sqlite3.dll
  if (!kIsWeb) {
    sqfliteWindowsFfiInit();
  }
}
