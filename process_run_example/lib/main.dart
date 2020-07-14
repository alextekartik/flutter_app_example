import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:process_run/shell.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Process run Example',
      theme: ThemeData(
        brightness: Brightness.dark,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Process run example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

abstract class Line {
  final String text;

  Line(this.text);
}

class ErrLine extends Line {
  ErrLine(String text) : super(text);
}

class OutLine extends Line {
  OutLine(String text) : super(text);
}

class _MyHomePageState extends State<MyHomePage> {
  Shell _shell;
  final _stdoutCtlr = StreamController<List<int>>();
  final _stderrCtlr = StreamController<List<int>>();
  final _linesCtlr = StreamController<List<Line>>();
  var _lines = <Line>[];

  void _addLine(Line line) {
    _lines.add(line);
    // Limit line count
    if (_lines.length > 100) {
      _lines = _lines.sublist(20);
    }
    _linesCtlr.add(_lines);
  }

  @override
  void initState() {
    super.initState();
    utf8.decoder
        .bind(_stdoutCtlr.stream)
        .transform(const LineSplitter())
        .listen((text) {
      _addLine(OutLine(text));
    });
    utf8.decoder
        .bind(_stderrCtlr.stream)
        .transform(const LineSplitter())
        .listen((text) {
      _addLine(ErrLine(text));
    });
    _shell = Shell(stdout: _stdoutCtlr.sink, stderr: _stderrCtlr.sink);
    _addLine(OutLine(
        'Press the button to run flutter doctor -v, see other commands in the menu'));
    _addLine(ErrLine('Error text will be displayed in red'));
  }

  void _run(String command) {
    _shell.run(command);
  }

  void flutterDoctor() {
    _run('flutter doctor -v');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // overflow menu
          PopupMenuButton<String>(
            onSelected: _run,
            itemBuilder: (BuildContext context) {
              return ['flutter --help', 'dart --version', 'dart --help']
                  .map((e) => PopupMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(growable: false);
            },
          ),
        ],
      ),
      body: ListView(
        reverse: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<List<Line>>(
              stream: _linesCtlr.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data
                      .map((line) => Text(
                            line.text ?? '',
                            style: line is ErrLine
                                ? TextStyle(color: Colors.red)
                                : null,
                          ))
                      .toList(growable: false),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: flutterDoctor,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _stdoutCtlr.close();
    _stderrCtlr.close();
    _linesCtlr.close();
    super.dispose();
  }
}
