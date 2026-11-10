import 'package:process_run/shell.dart';

Future<void> main() async {
  await setupWeb();
}

Future<void> setupWeb() async {
  await run('flutter pub get');
  await run('dart run sqflite_common_ffi_web:setup --force');
}
