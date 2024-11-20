import 'package:process_run/stdio.dart';

import 'setup_sqflite_web.dart';

Future<void> main(List<String> args) async {
  var webDir = Directory('web');
  if (webDir.existsSync()) {
    await webDir.delete(recursive: true);
  }
  await setupWeb();
}
