import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../image_processing/image_processing_module.dart';

class BlurImage extends ConsumerStatefulWidget {
  const BlurImage();

  @override
  ConsumerState<BlurImage> createState() => _BlurImageState();
}

class _BlurImageState extends ConsumerState<BlurImage> {
  ui.Image? _resultImage;
  String? _processingTime;

  Future<void> _sendImage() async {
    Stopwatch stopwatch = Stopwatch()..start();
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
    Uint8List processedImage = await ref
        .read(imageProcessingRepositoryProvider)
        .blurImage(rawUint8List, width, height);
    ui.decodeImageFromPixels(
        processedImage, width, height, ui.PixelFormat.rgba8888, (result) {
      setState(() {
        _resultImage = result;
        _processingTime = stopwatch.elapsed.inMilliseconds.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Blur Image using c++'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            _ImageAndCaption(
              image: Image.asset('assets/images/face.png'),
              caption: 'Input Image',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendImage,
              child: const Text('Send Image'),
            ),
            const SizedBox(height: 20),
            if (_resultImage != null)
              _ImageAndCaption(
                image: RawImage(image: _resultImage!),
                caption: 'Image processed in ${_processingTime}ms',
              ),
          ],
        ),
      ),
    );
  }
}

class _ImageAndCaption extends StatelessWidget {
  final Widget image;
  final String caption;

  const _ImageAndCaption({required this.image, required this.caption});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: image,
        ),
        Text(caption),
      ],
    );
  }
}
