import 'demoidb_project_generate.dart' as demoidb;
import 'notepad_project_generate.dart' as notepad;

Future main() async {
  await generateAll();
}

Future generateAll({bool force}) async {
  await demoidb.generate(force: force);
  await notepad.generate(force: force);
}
