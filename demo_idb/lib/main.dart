// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_idb/idb.dart';
import 'package:tekartik_app_platform/app_platform.dart';

import 'app_io.dart' if (dart.library.js_interop) 'app_web.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  appInit();
  run(idbFactory: idbFactory);
}

void run({required IdbFactory idbFactory}) {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  appInit();
  var bloc = MyAppBloc(idbFactory: idbFactory);
  runApp(MyApp(bloc: bloc));
}

var storeName = 'counter';
var valueKey = 'value';

class MyAppBloc {
  final IdbFactory idbFactory;

  Future<int> readValue(ObjectStore store) async {
    var rawValue = await store.getObject(valueKey);
    return (rawValue as num?)?.toInt() ?? 0;
  }

  MyAppBloc({required this.idbFactory}) {
    // Load counter on start
    () async {
      var db = await database;
      var txn = db.transaction(storeName, idbModeReadOnly);
      var store = txn.objectStore(storeName);
      var value = await readValue(store);
      // In wasm we might get a double !
      //_value = (((await store.getObject(valueKey)) as num?)?.toInt()) ?? 0;
      _counterController.add(value);
    }();
  }

  late Future<Database> database = () async {
    var db = await idbFactory.open(
      'counter.db',
      version: 1,
      onUpgradeNeeded: (e) {
        var db = e.database;
        db.createObjectStore(storeName);
      },
    );
    return db;
  }();

  final StreamController<int?> _counterController =
      StreamController<int>.broadcast();

  Stream<int> get counter => _counterController.stream as Stream<int>;

  Future increment() async {
    var db = await database;
    var txn = db.transaction(storeName, idbModeReadWrite);
    var store = txn.objectStore(storeName);
    var value = await readValue(store) + 1;

    await store.put(value, valueKey);
    _counterController.add(value);
  }
}

class MyApp extends StatelessWidget {
  final MyAppBloc bloc;

  const MyApp({super.key, required this.bloc});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with 'flutter run'. You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // 'hot reload' (press 'r' in the console where you ran 'flutter run',
        // or simply save your changes to 'hot reload' in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', bloc: bloc),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final MyAppBloc bloc;

  const MyHomePage({super.key, required this.title, required this.bloc});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.bloc.counter,
      builder: (context, snapshot) {
        var count = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (count != null) ...[
                  Text('You have pushed the button this many times:'),
                  Text('$count', style: Theme.of(context).textTheme.labelLarge),
                ],
              ],
            ),
          ),
          floatingActionButton: count != null
              ? FloatingActionButton(
                  onPressed: () {
                    widget.bloc.increment();
                  },
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
