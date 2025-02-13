// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sembast_web/sembast_web_interop.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_demosembast_app/src/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  var databaseFactory = databaseFactoryWeb;

  var bloc = MyAppBloc(databaseFactory);
  runApp(MyApp(bloc: bloc));
}
