import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:idb_shim/sdb.dart';

var valueKey = 'value';
var store = SdbStoreRef<String, int>('main');
var record = store.record(valueKey);

class MyAppBloc {
  final SdbFactory databaseFactory;
  MyAppBloc(this.databaseFactory) {
    database = () async {
      var db = await databaseFactory.openDatabase(
        'counter.sdb',
        options: SdbOpenDatabaseOptions(
          version: 1,
          schema: SdbDatabaseSchema(stores: [store.schema()]),
        ),
      );
      return db;
    }();
    // Load counter on start
    () async {
      var db = await database;
      _streamSubscription = record.onSnapshot(db).listen((snapshot) {
        _counterController.add(snapshot?.value ?? 0);
      });
    }();
  }

  late StreamSubscription _streamSubscription;

  late final Future<SdbDatabase> database;

  final _counterController = StreamController<int>.broadcast();

  Stream<int> get counter => _counterController.stream;

  Future increment() async {
    var db = await database;
    await db.inStoreTransaction(store, SdbTransactionMode.readWrite, (
      txn,
    ) async {
      var value = await record.getValue(txn) ?? 0;
      await record.put(txn, ++value);
    });
  }

  void dispose() {
    _streamSubscription.cancel();
  }
}

class MyApp extends StatelessWidget {
  final MyAppBloc bloc;

  const MyApp({super.key, required this.bloc});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDB Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
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
      home: MyHomePage(title: 'SDB Demo', bloc: bloc),
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
                  if (kIsWeb)
                    const Text(
                      '(You can open multiples tabs and see that they are synchronized)',
                    ),
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$count',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
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
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }
}
