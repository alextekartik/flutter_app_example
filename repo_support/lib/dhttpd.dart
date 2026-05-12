import 'package:dev_build/package.dart';

Future<void> checkOrPubActivateDhttpd() async {
  await checkOrPubActivateHostedPackage(
    'dhttpd',
    versionBoundaries: VersionBoundaries.lower(Version(4, 3, 0)),
  );
}
