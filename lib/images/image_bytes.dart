import 'dart:typed_data';

enum Format {
  rgba,
  grayscale;
}

class ImageBytes {
  final Uint8List buffer;
  final int width;
  final int height;
  final Format format;

  ImageBytes({
    required this.buffer,
    required this.width,
    required this.height,
    required this.format,
  });
}

// final class ImageData extends Struct {
//   @Int32()
//   external int width;
//
//   @Int32()
//   external int height;
//
//   external Pointer<Uint8> data;
// }
