import 'package:process_run/shell.dart';

Future<void> main() async {
  await run('flutter run -d chrome --target lib/main.dart');
}
