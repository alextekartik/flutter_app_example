import 'package:tekartik_flutter_build/app_build.dart';
import 'package:tekartik_web_publish/surge_web_publish.dart';

var webAppBuilder = FlutterWebAppBuilder(
  deployer: SurgeWebAppDeployer(
    options: SurgeWebAppDeployOptions(domain: 'demo_sdb.surge.sh'),
  ),
  options: FlutterWebAppOptions(
    buildOptions: FlutterWebAppBuildOptions(wasm: true),
  ),
);
Future<void> main() async {
  await webAppBuilder.buildAndServe();
}
