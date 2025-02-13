import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:tekartik_demo_sqflite/counter_database.dart';

final counterDb = CounterDatabase();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Use sqflite on Mac/Android/iOS
  // On the web using sqflite_common_ffi_web (need setup)
  if (kIsWeb) {
    databaseFactoryOrNull = databaseFactoryFfiWeb;
  } else if (Platform.isLinux || Platform.isWindows) {
    // Use the ffi version on linux and windows
    sqfliteFfiInit();
    databaseFactoryOrNull = databaseFactoryFfi;
  }
  // More log to see the executed queries
  // ignore: deprecated_member_use
  databaseFactoryOrNull = databaseFactory.debugQuickLoggerWrapper();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite counter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Flutter SQLite counter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    counterDb.incrementCounter().then((_) {
      // Force ui update
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            FutureBuilder<int>(
              future: counterDb.getCounter(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
