import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class GreyscaleEngine {

  static Future<ui.Image> applyGreyscale(File? imageFile) async {
    if (imageFile == null) {
      throw Exception("No image file selected");
    }

    // read image file as bytes
    final bytes = await imageFile.readAsBytes();

    // decode the image
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;

    // extract raw rgba bytes
    final byteData = await uiImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );

    if (byteData == null) throw Exception("Failed to extract raw rgba bytes");

    final rgbaBytes = byteData.buffer.asUint8List();

    // Convert to greyscale
    final greyBytes = await convertToGreyscale(
      rgbaBytes,
      uiImage.width,
      uiImage.height,
    );

    // rebuild image from greyscale bytes
    final buffer = await ui.ImmutableBuffer.fromUint8List(greyBytes);
    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: uiImage.width,
      height: uiImage.height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    final codec2 = await descriptor.instantiateCodec();
    final frame2 = await codec2.getNextFrame();
    return frame2.image;
  }

  static Future<Uint8List> convertToGreyscale(
      Uint8List rgbaBytes,
      int width,
      int height,
      ) async {
    // create a buffer for greyscale output
    Uint8List greyscaleBytes = Uint8List(rgbaBytes.length);

    int pixelCount = width * height;

    for (int i = 0; i < pixelCount; ++i) {
      int byteIndex = i * 4;

      int r = rgbaBytes[byteIndex];
      int g = rgbaBytes[byteIndex + 1];
      int b = rgbaBytes[byteIndex + 2];

      // Weighted luminance formula from wikipedia
      double luminance = 0.299 * r + 0.587 * g + 0.114 * b;

      int grey = luminance.toInt();

      // set all channels (R,G,B) to same greyscale value
      greyscaleBytes[byteIndex] = grey;
      greyscaleBytes[byteIndex + 1] = grey;
      greyscaleBytes[byteIndex + 2] = grey;

      // preserve alpha channel
      greyscaleBytes[byteIndex + 3] = rgbaBytes[byteIndex + 3];
    }
    return greyscaleBytes;
  }
}