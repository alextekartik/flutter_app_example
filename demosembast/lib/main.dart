import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tekartik_app_flutter_sembast/sembast.dart';
import 'package:tekartik_app_platform/app_platform.dart';
import 'package:tekartik_app_flutter_sembast/setup/sembast_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  platformInit();
  var packageName = 'com.tekartik.demosembast';

  var databaseFactory = await initDatabaseFactory(packageName: packageName);

  var bloc = MyAppBloc(databaseFactory);
  runApp(MyApp(
    bloc: bloc,
  ));
}

var valueKey = 'value';
var store = StoreRef<String, int>.main();
var record = store.record(valueKey);

class MyAppBloc {
  final DatabaseFactory databaseFactory;
  MyAppBloc(this.databaseFactory) {
    database = () async {
      var db = await databaseFactory.openDatabase('counter.db');
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

  StreamSubscription _streamSubscription;

  Future<Database> database;

  final _counterController = StreamController<int>.broadcast();

  Stream<int> get counter => _counterController.stream;

  Future increment() async {
    var db = await database;
    await db.transaction((txn) async {
      var value = await record.get(txn) ?? 0;
      await record.put(txn, ++value);
    });
  }

  void dispose() {
    _streamSubscription.cancel();
  }
}

class MyApp extends StatelessWidget {
  final MyAppBloc bloc;

  const MyApp({Key key, @required this.bloc}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sembast Demo',
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
      home: MyHomePage(
        title: 'Sembast Demo',
        bloc: bloc,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final MyAppBloc bloc;

  MyHomePage({Key key, this.title, @required this.bloc}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked 'final'.

  final String title;

  @override
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
                      Text(
                        '(You can open multiples tabs and see that they are synchronized)',
                      ),
                    Text(
                      'You have pushed the button this many times:',
                    ),
                    Text('$count',
                        style:
                            // ignore: deprecated_member_use
                            Theme.of(context).textTheme.display1)
                  ]
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
        });
  }

  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }
}
