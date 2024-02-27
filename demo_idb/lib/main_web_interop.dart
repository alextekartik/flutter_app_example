// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:idb_shim/idb_client_native_web.dart';
import 'package:tekartik_app_platform/app_platform.dart';

import 'main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  run(idbFactory: idbFactoryNative);
}
