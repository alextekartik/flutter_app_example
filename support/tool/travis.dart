import 'package:tekartik_build_utils/common_import.dart';
import 'projects_generate.dart' as projects_generate;
import 'test_all.dart' as test_all;

Future main() async {
  var flutterVersion = await getFlutterVersion();
  if (flutterVersion < Version(1, 10, 1)) {
    print('Flutter version $flutterVersion not compatible');
    return;
  }
  await projects_generate.generateAll(force: true);
  await test_all.main();
}
