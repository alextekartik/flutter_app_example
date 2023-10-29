// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/shell.dart';
import 'package:pub_semver/pub_semver.dart';

final appVersion = Version(0, 1, 0);

void main() {
  runApp(ProcessRunExampleApp());
}

class ProcessRunExampleApp extends StatelessWidget {
  ProcessRunExampleApp({super.key});
  // This widget is the root of your application.
  final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Process run Example',
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
        secondary: Colors.cyan[600],
      )),
      home: const MainPage(title: 'Process run example'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

abstract class Line {
  final String text;

  Line(this.text);
}

class ErrLine extends Line {
  ErrLine(super.text);
}

class OutLine extends Line {
  OutLine(super.text);
}

/// Basic line streaming. Assuming system encoding
Stream<String> streamLines(Stream<List<int>> stream,
    {Encoding encoding = systemEncoding}) {
  StreamSubscription? subscription;
  List<int>? currentLine;
  const endOfLine = 10;
  const lineFeed = 13;
  late StreamController<String> ctlr;
  ctlr = StreamController<String>(onListen: () {
    void addCurrentLine() {
      if (currentLine?.isNotEmpty ?? false) {
        try {
          ctlr.add(systemEncoding.decode(currentLine!));
        } catch (_) {
          // Ignore nad encoded line
          // print('ignoring: $currentLine');
        }
      }
      currentLine = null;
    }

    void addToCurrentLine(List<int> data) {
      if (currentLine == null) {
        currentLine = data;
      } else {
        var newCurrentLine = Uint8List(currentLine!.length + data.length);
        newCurrentLine.setAll(0, currentLine!);
        newCurrentLine.setAll(currentLine!.length, data);
        currentLine = newCurrentLine;
      }
    }

    subscription = stream.listen((data) {
      // var _w;
      // print('read $data');
      // devPrint('read $data');
      // look for \n (10)
      var start = 0;
      for (var i = 0; i < data.length; i++) {
        var byte = data[i];
        if (byte == endOfLine || byte == lineFeed) {
          addToCurrentLine(data.sublist(start, i));
          addCurrentLine();
          // Skip it
          start = i + 1;
        }
      }
      // Store last current line
      if (data.length > start) {
        addToCurrentLine(data.sublist(start, data.length));
      }
    }, onDone: () {
      // Last one
      if (currentLine != null) {
        addCurrentLine();
      }
      ctlr.close();
    });
  }, onCancel: () {
    subscription?.cancel();
  });

  return ctlr.stream;
}

class _MainPageState extends State<MainPage> {
  late Shell _shell;
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
    streamLines(_stdoutCtlr.stream).listen((line) {
      _addLine(OutLine(line));
    });
    streamLines(_stderrCtlr.stream).listen((line) {
      _addLine(ErrLine(line));
    });
    /*
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

     */
    _shell = Shell(stdout: _stdoutCtlr.sink, stderr: _stderrCtlr.sink);
    _addLine(OutLine(
        'Press the button to run flutter doctor -v, see other commands in the menu'));
    _addLine(ErrLine('Error text will be displayed in red'));
  }

  Future _run(String command) async {
    if (command == '@info') {
      _addLine(OutLine('appVersion: $appVersion'));
      _addLine(OutLine('dartExecutable: $dartExecutable'));
      _addLine(OutLine('flutterExecutablePath: $flutterExecutablePath'));
      _addLine(OutLine('which(\'dart\'): ${await which('dart')}'));
      _addLine(OutLine('which(\'flutter\'): ${await which('flutter')}'));
      _addLine(OutLine('which(\'pub\'): ${await which('pub')}'));
      try {
        _addLine(OutLine('DartCmd(\'--version\'): ${(await runCmd(DartCmd([
              '--version'
            ]))).stderr.toString().trim()}'));
      } catch (e) {
        _addLine(ErrLine('DartCmd(\'--version\') error $e'));
      }
      try {
        _addLine(OutLine(
            'FlutterCmd(\'--version\'): ${(await runCmd(FlutterCmd([
              '--version'
            ]))).stdout.toString().trim()}'));
      } catch (e) {
        _addLine(ErrLine('FlutterCmd(\'--version\') error $e'));
      }
      try {
        _addLine(OutLine('PubCmd(\'--version\'): ${(await runCmd(PubCmd([
              '--version'
            ]))).stdout.toString().trim()}'));
      } catch (e) {
        _addLine(ErrLine('PubCmd(\'--version\') error $e'));
      }
      _addLine(OutLine('$userHomePath: $userHomePath'));
      _addLine(OutLine('$userAppDataPath: $userAppDataPath'));
      await _shell.run('flutter --version');
      await _shell.run('dart --version');
      await _shell.run('pub --version');
    } else if (command == '@userEnv') {
      _addLine(OutLine(
          'userEnvironment: ${const JsonEncoder.withIndent('  ').convert(userEnvironment)}'));
    } else if (command == '@path') {
      for (var element in userPaths) {
        _addLine(OutLine(element));
      }
    } else {
      await _shell.run(command);
    }
  }

  Future runCustomCommand() async {
    var command = await _readCommand();
    if (command != null) {
      await _shell.run(command);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          // overflow menu
          PopupMenuButton<String>(
            onSelected: _run,
            itemBuilder: (BuildContext context) {
              return [
                'flutter --version',
                'flutter --help',
                'flutter doctor -v',
                'dart --version',
                'dart --help',
                'pub --version',
                'pub --help',
                '@info',
                '@path',
                '@userEnv'
              ]
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
                  children: snapshot.data!
                      .map((line) => Text(
                            line.text,
                            style: line is ErrLine
                                ? const TextStyle(color: Colors.red)
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
        onPressed: runCustomCommand,
        tooltip: 'Custom command',
        // ignore: prefer_const_constructors
        child: Icon(Icons.arrow_right),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  TextEditingController? _commandInputController;

  Future<String?> _readCommand() async {
    _commandInputController?.dispose();
    var textValue = _commandInputController?.text ?? 'echo "Hello World!"';
    _commandInputController = TextEditingController(text: textValue);
    _commandInputController!.selection = TextSelection(
      baseOffset: 0,
      extentOffset: textValue.length,
    );

    void run() {
      Navigator.pop(context, _commandInputController!.text);
    }

    return await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: _commandInputController,
              autofocus: true,
              onSubmitted: (_) => run(),
              decoration: InputDecoration(
                  labelText: 'Full command', hintText: 'Command'),
            )),
          ],
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          TextButton(
              child: const Text('RUN'),
              onPressed: () {
                run();
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stdoutCtlr.close();
    _stderrCtlr.close();
    _linesCtlr.close();
    _commandInputController?.dispose();
    super.dispose();
  }
}
