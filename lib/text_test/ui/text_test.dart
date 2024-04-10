import 'package:facefinder/image_processing/image_processing_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextTest extends ConsumerStatefulWidget {
  const TextTest();

  @override
  ConsumerState<TextTest> createState() => _TextTestState();
}

class _TextTestState extends ConsumerState<TextTest> {
  String? _screenText;

  void _callHello(String input) async {
    var resultString =
        await ref.read(imageProcessingRepositoryProvider).hello(input);

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
