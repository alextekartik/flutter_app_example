// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idb_shim/idb_client_native.dart';
// ignore: implementation_imports
import 'package:idb_shim/src/native_web/js_utils.dart';
// ignore: implementation_imports
import 'package:idb_shim/src/utils/env_utils.dart';

import 'main.dart';
//import 'package:tekartik_app_platform/app_platform.dart';

void main() {
  /// Wasm compatible
  WidgetsFlutterBinding.ensureInitialized();
  interopQuickExperiment();
  var factory = idbFactoryNative;
  var bloc = MyAppBloc(idbFactory: factory);
  runApp(MyApp(bloc: bloc));
}

extension on Object? {
  String runtimeTypeToString() {
    if (this is bool) {
      return 'bool';
    } else if (this == null) {
      return 'Null';
    } else if (this is int) {
      return 'int';
    } else if (this is double) {
      return 'double';
    } else if (this is String) {
      return 'String';
    } else if (this is Uint8List) {
      return 'Uint8List';
    } else if (this is DateTime) {
      return 'DateTime';
    } else if (this is List) {
      return 'List';
    } else if (this is Map) {
      return 'Map';
    }
    return runtimeType.toString();
  }
}

void interopQuickExperiment() {
  if (kIsWeb) {
    print(
      'kIsWeb: $kIdbDartIsWeb, isRunningAsJavascript: $idbIsRunningAsJavascript',
    );

    for (var value in [
      null,
      1,
      2.5,
      'text',
      true,
      Uint8List.fromList([1, 2, 3]),
      DateTime(2024, 3, 15, 12, 0, 0),
      {
        'list': [1, 2, 3],
      },
      [
        {
          'map': {'sub': '1, 2, 3'},
        },
      ],
    ]) {
      print('value: $value (${value.runtimeTypeToString()})');

      try {
        var jsified = value.jsify();

        try {
          var dartified = jsified.dartify();
          print(
            'jsify/dartify: $dartified (${dartified.runtimeTypeToString()})',
          );
        } catch (e) {
          print('error re-dartifying $value: $e');
        }
        try {
          var dartified = jsified?.dartifyValueStrict();
          print(
            'jsify/dartifyValueStrict: $dartified (${dartified.runtimeTypeToString()})',
          );
        } catch (e) {
          print('error re-dartifyingValueStrict $value: $e');
        }
      } catch (e) {
        print('error jisifying $value: $e');
      }
      try {
        var jsified = value?.jsifyValueStrict();

        try {
          var dartified = jsified.dartify();
          print(
            'jsifyValueStrict/dartify: $dartified (${dartified.runtimeTypeToString()})',
          );
        } catch (e) {
          print('error re-dartifying $value: $e');
        }
        try {
          var dartified = jsified?.dartifyValueStrict();
          print(
            'jsifyValueStrict/dartifyValueStrict: $dartified (${dartified.runtimeTypeToString()})',
          );
        } catch (e) {
          print('error re-dartifying $value: $e');
        }
      } catch (e) {
        print('error jisifying $value: $e');
      }
    }
  }
}

/*
Running as wasm

value: null (Null)
jsify/dartify: null (Null)
error re-dartifyingValueStrict null: Unsupported operation: Unsupported value: null (type: minified:Class316)
jsifyValueStrict/dartify: null (Null)
jsifyValueStrict/dartifyValueStrict: null (Null)
value: 1 (int)
jsify/dartify: 1.0 (double)
jsify/dartifyValueStrict: 1 (int)
jsifyValueStrict/dartify: 1.0 (double)
jsifyValueStrict/dartifyValueStrict: 1 (int)
value: 2.5 (double)
jsify/dartify: 2.5 (double)
jsify/dartifyValueStrict: 2.5 (double)
jsifyValueStrict/dartify: 2.5 (double)
jsifyValueStrict/dartifyValueStrict: 2.5 (double)
value: text (String)
jsify/dartify: text (String)
jsify/dartifyValueStrict: text (String)
jsifyValueStrict/dartify: text (String)
jsifyValueStrict/dartifyValueStrict: text (String)
value: true (bool)
jsify/dartify: true (bool)
jsify/dartifyValueStrict: true (bool)
jsifyValueStrict/dartify: true (bool)
jsifyValueStrict/dartifyValueStrict: true (bool)
value: [1, 2, 3] (Uint8List)
jsify/dartify: [1, 2, 3] (Uint8List)
jsify/dartifyValueStrict: [1, 2, 3] (Uint8List)
jsifyValueStrict/dartify: [1, 2, 3] (Uint8List)
jsifyValueStrict/dartifyValueStrict: [1, 2, 3] (Uint8List)
value: 2024-03-15 12:00:00.000 (DateTime)
jsify/dartify: {} (Map)
jsify/dartifyValueStrict: {} (Map)
jsifyValueStrict/dartify: Fri Mar 15 2024 12:00:00 GMT+0100 (Central European Standard Time) (minified:Class316)
jsifyValueStrict/dartifyValueStrict: 2024-03-15 11:00:00.000Z (DateTime)
value: {list: [1, 2, 3]} (Map)
jsify/dartify: {list: [1.0, 2.0, 3.0]} (Map)
jsify/dartifyValueStrict: {list: [1, 2, 3]} (Map)
jsifyValueStrict/dartify: {list: [1.0, 2.0, 3.0]} (Map)
jsifyValueStrict/dartifyValueStrict: {list: [1, 2, 3]} (Map)
value: [{map: {sub: 1, 2, 3}}] (List)
jsify/dartify: [{map: {sub: 1, 2, 3}}] (List)
jsify/dartifyValueStrict: [{map: {sub: 1, 2, 3}}] (List)
jsifyValueStrict/dartify: [{map: {sub: 1, 2, 3}}] (List)
jsifyValueStrict/dartifyValueStrict: [{map: {sub: 1, 2, 3}}] (List)

Running as js
value: null (Null)
jsify/dartify: null (Null)
jsify/dartifyValueStrict: null (Null)
jsifyValueStrict/dartify: null (Null)
jsifyValueStrict/dartifyValueStrict: null (Null)
value: 1 (int)
jsify/dartify: 1 (int)
jsify/dartifyValueStrict: 1 (int)
jsifyValueStrict/dartify: 1 (int)
jsifyValueStrict/dartifyValueStrict: 1 (int)
value: 2.5 (double)
jsify/dartify: 2.5 (double)
jsify/dartifyValueStrict: 2.5 (double)
jsifyValueStrict/dartify: 2.5 (double)
jsifyValueStrict/dartifyValueStrict: 2.5 (double)
value: text (String)
jsify/dartify: text (String)
jsify/dartifyValueStrict: text (String)
jsifyValueStrict/dartify: text (String)
jsifyValueStrict/dartifyValueStrict: text (String)
value: true (bool)
jsify/dartify: true (bool)
jsify/dartifyValueStrict: true (bool)
jsifyValueStrict/dartify: true (bool)
jsifyValueStrict/dartifyValueStrict: true (bool)
value: [1, 2, 3] (Uint8List)
jsify/dartify: [1, 2, 3] (Uint8List)
jsify/dartifyValueStrict: [1, 2, 3] (Uint8List)
jsifyValueStrict/dartify: [1, 2, 3] (Uint8List)
jsifyValueStrict/dartifyValueStrict: [1, 2, 3] (Uint8List)
value: 2024-03-15 12:00:00.000 (DateTime)
jsify/dartify: 2024-03-15 12:00:00.000 (DateTime)
jsify/dartifyValueStrict: 2024-03-15 12:00:00.000 (DateTime)
jsifyValueStrict/dartify: 2024-03-15 11:00:00.000Z (DateTime)
jsifyValueStrict/dartifyValueStrict: 2024-03-15 11:00:00.000Z (DateTime)
value: {list: [1, 2, 3]} (Map)
jsify/dartify: {list: [1, 2, 3]} (Map)
jsify/dartifyValueStrict: {list: [1, 2, 3]} (Map)
jsifyValueStrict/dartify: {list: [1, 2, 3]} (Map)
jsifyValueStrict/dartifyValueStrict: {list: [1, 2, 3]} (Map)
value: [{map: {sub: 1, 2, 3}}] (List)
jsify/dartify: [{map: {sub: 1, 2, 3}}] (List)
jsify/dartifyValueStrict: [{map: {sub: 1, 2, 3}}] (List)
jsifyValueStrict/dartify: [{map: {sub: 1, 2, 3}}] (List)
jsifyValueStrict/dartifyValueStrict: [{map: {sub: 1, 2, 3}}] (List)
 */
