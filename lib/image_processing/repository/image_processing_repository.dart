import 'dart:typed_data';

abstract class ImageProcessingRepository {
  Future<String> hello(String input);

  Future<Uint8List> blurImage(Uint8List pixels, int width, int height);
}
