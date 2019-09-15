import 'demoidb_project_generate.dart' as demoidb;
Future main() async {
  await generateAll();
}

Future generateAll({bool force}) async{
  await demoidb.generate(force: force);
}