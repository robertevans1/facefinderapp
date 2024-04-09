import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef HelloFunction = Pointer<Utf8> Function(Pointer<Utf8>);
typedef ProcessImage = Pointer<Uint8> Function(
    Pointer<Uint8>, Int32, Int32, Int32);
typedef ProcessImageDart = Pointer<Uint8> Function(
    Pointer<Uint8>, int, int, int);

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _screenText = 'initial text';
  ui.Image? _resultImage;

  String _getLibraryPath() {
    if (Platform.isAndroid) {
      return 'libdetect_faces.so';
    } else {
      throw Exception('Unsupported platform');
    }
  }

  void _callHello() async {
    DynamicLibrary cppLib = DynamicLibrary.open(_getLibraryPath());
    var helloFunc =
        cppLib.lookupFunction<HelloFunction, HelloFunction>('hello');
    var inputString = 'good';
    var inputCString = inputString.toNativeUtf8();

    // Call the native function with the C string
    var resultPointer = helloFunc(inputCString);

    // Convert the result back to Dart string
    var resultString = resultPointer.toDartString();

    setState(() {
      _screenText = 'Sent $inputString got $resultString';
    });
  }

  Future<Uint8List> _processImage(
      Uint8List pixels, int width, int height) async {
    DynamicLibrary cppLib = DynamicLibrary.open(_getLibraryPath());
    var processImageFunc =
        cppLib.lookupFunction<ProcessImage, ProcessImageDart>('blurImage');

    final imgPtr = malloc.allocate<Uint8>(pixels.length);

    imgPtr.asTypedList(pixels.length).setAll(0, pixels);

    // Call the native function with the C string
    var resultPointer = processImageFunc(imgPtr, width, height, 4);

    // Copy result back into dart buffer
    Uint8List resultPixels =
        Uint8List.fromList(resultPointer.asTypedList(width * height * 4));

    malloc.free(imgPtr);

    return resultPixels;
  }

  Future<void> _sendImage() async {
    // Load the image asset
    ByteData imageData = await rootBundle.load('assets/images/face.png');

    // Convert ByteData to Uint8List
    Uint8List uint8List = Uint8List.view(imageData.buffer);

    // Decode image to get its metadata
    ui.Codec codec = await ui.instantiateImageCodec(uint8List);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    int width = frameInfo.image.width;
    int height = frameInfo.image.height;

    ByteData? rawBytes = await frameInfo.image.toByteData();
    // Convert ByteData to Uint8List
    Uint8List rawUint8List = Uint8List.view(rawBytes!.buffer);
    Uint8List processedImage = await _processImage(rawUint8List, width, height);
    ui.decodeImageFromPixels(
        processedImage, width, height, ui.PixelFormat.rgba8888, (result) {
      setState(() {
        _screenText = 'Image processed';
        _resultImage = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Process Image using c++'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _screenText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/face.png'),
            ),
            ElevatedButton(
              onPressed: _sendImage,
              child: const Text('Send Image'),
            ),
            if (_resultImage != null)
              SizedBox(
                height: 200,
                width: 200,
                child: RawImage(image: _resultImage),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _callHello,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
