import 'package:process_run/shell.dart';

Future<void> main() async {
  await run('flutter build web --wasm --target lib/main_web_interop.dart');
}
