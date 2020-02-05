import 'dart:io';

import 'package:sqflite_ffi_test/sqflite_ffi_test.dart';

void appInit() {
  if (Platform.isLinux) {
    sqfliteFfiTestInit();
  }
}
