// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_demosembast_app/src/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  var packageName = 'com.tekartik.demosembast';

  var databaseFactory = getDatabaseFactory(packageName: packageName);

  var bloc = MyAppBloc(databaseFactory);
  runApp(MyApp(bloc: bloc));
}
