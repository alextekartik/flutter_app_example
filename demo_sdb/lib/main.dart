import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_idb/sdb.dart';
import 'package:tekartik_demosdb_app/src/app.dart';
import 'package:tekartik_web_splash/web_splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  webSplashReady();
  var packageName = 'com.tekartik.demosdb';

  var databaseFactory = getSdbFactory(packageName: packageName);

  var bloc = MyAppBloc(databaseFactory);
  webSplashHide();
  runApp(MyApp(bloc: bloc));
}
