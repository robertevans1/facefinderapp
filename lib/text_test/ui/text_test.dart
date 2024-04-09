import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

typedef _HelloFunction = Pointer<Utf8> Function(Pointer<Utf8>);

class TextTest extends StatefulWidget {
  const TextTest();

  @override
  State<TextTest> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest> {
  String? _screenText;

  String _getLibraryPath() {
    if (Platform.isAndroid) {
      return 'libdetect_faces.so';
    } else {
      throw Exception('Unsupported platform');
    }
  }

  void _callHello(String input) async {
    DynamicLibrary cppLib = DynamicLibrary.open(_getLibraryPath());
    var helloFunc =
        cppLib.lookupFunction<_HelloFunction, _HelloFunction>('hello');
    var inputCString = input.toNativeUtf8();

    // Call the native function with the C string
    var resultPointer = helloFunc(inputCString);

    // Convert the result back to Dart string
    var resultString = resultPointer.toDartString();

    setState(() {
      _screenText = 'Sent: $input\nReceived: $resultString';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Text test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
                "To check the c++ library is correctly loaded in this app,"
                " call a test method in the library."
                " If test method receives the string 'hello c++' it responds 'hello from c++'"
                " otherwise it should respond 'who are you?'"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _callHello('hello c++'),
              child: const Text("Send 'hello c++'"),
            ),
            ElevatedButton(
              onPressed: () => _callHello("What's up?"),
              child: const Text("Send 'What's up?'"),
            ),
            const SizedBox(height: 20),
            if (_screenText != null)
              Text(
                _screenText!,
              ),
          ],
        ),
      ),
    );
  }
}
