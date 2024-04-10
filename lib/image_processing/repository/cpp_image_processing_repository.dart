import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:facefinder/image_processing/repository/image_processing_repository.dart';
import 'package:ffi/ffi.dart';

typedef ProcessImage = Pointer<Uint8> Function(
    Pointer<Uint8>, Int32, Int32, Int32);
typedef ProcessImageDart = Pointer<Uint8> Function(
    Pointer<Uint8>, int, int, int);

typedef _HelloFunction = Pointer<Utf8> Function(Pointer<Utf8>);

class CppImageProcessingRepository implements ImageProcessingRepository {
  DynamicLibrary cppLib = DynamicLibrary.open(_getLibraryPath());

  @override
  Future<String> hello(String input) async {
    try {
      var helloFunc =
          cppLib.lookupFunction<_HelloFunction, _HelloFunction>('hello');
      var inputCString = input.toNativeUtf8();

      // Call the native function with the C string
      var resultPointer = helloFunc(inputCString);

      // Convert the result back to Dart string
      return resultPointer.toDartString();
    } catch (e) {
      return 'Error occurred';
    }
  }

  @override
  Future<Uint8List> blurImage(Uint8List pixels, int width, int height) async {
    try {
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
    } catch (e) {
      return Uint8List(0);
    }
  }
}

String _getLibraryPath() {
  if (Platform.isAndroid) {
    return 'libdetect_faces.so';
  } else {
    print('Unsupported platform');
    return '';
  }
}
