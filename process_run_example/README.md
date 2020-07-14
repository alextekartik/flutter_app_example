# `process_run` example

Simple example or running a command and capturing the output in a widget.

Tested on Linux

Goal:
* Create a Create sink
* Call `shell.run`
* Capture and display output in a widget

This is not intended to be the perfect way of doing things...

## Setup

Project files are not checked in, simply run:

```bash
flutter create .
flutter run
```

To allow running on Linux. Make sure you are on the proper flutter channel (as of 2020/07/01: beta for the web, dev for MacOS/Linux, master for Windows)