import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idb_shim/sdb.dart';
import 'package:tekartik_demosdb_app/src/app.dart';
import 'package:tekartik_web_splash/web_splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  webSplashReady();
  var databaseFactory = sdbFactoryWeb;

  var bloc = MyAppBloc(databaseFactory);
  webSplashHide();
  runApp(MyApp(bloc: bloc));
}
