import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

class WavDecoderImageEngine {
  static Future<ui.Image> wavToGreyScale(File wavFile) async {
    Uint8List wavBytes = await wavFile.readAsBytes();

    List<int> size = readImageDimension(wavBytes);

    int width = size[0];
    int height = size[1];

    Float32List samples = extractSamples(wavBytes);

    Uint8List rgbaBytes = samplesToPixels(samples, width, height);

    final buffer = await ui.ImmutableBuffer.fromUint8List(rgbaBytes);

    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );

    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();

    return frame.image;
  }

  static Float32List extractSamples(Uint8List wavBytes) {
    ByteData data = wavBytes.buffer.asByteData();

    int dataStart = 0;
    int dataSize = 0;

    for (int i = 0; i < wavBytes.length - 4; i++) {
      if (wavBytes[i] == 100 && // d
          wavBytes[i + 1] == 97 && // a
          wavBytes[i + 2] == 116 && // t
          wavBytes[i + 3] ==
              97 // a
              ) {
        dataSize = data.getInt32(i + 4, Endian.little);

        dataStart = i + 8;
        break;
      }
    }

    int sampleCount = dataSize ~/ 2;

    Float32List samples = Float32List(sampleCount);

    for (int i = 0; i < sampleCount; i++) {
      int offset = dataStart + i * 2;
      int sampleInt = data.getInt16(offset, Endian.little);
      samples[i] = sampleInt / 32767.0;
    }

    return samples;
  }

  static Uint8List samplesToPixels(Float32List samples, int width, int height) {
    int pixelCount = width * height;

    Uint8List rgbaBytes = Uint8List(pixelCount * 4);

    for (int i = 0; i < pixelCount; ++i) {
      double s = samples[i];

      int grey = (((s + 1) / 2) * 255).toInt();

      int byteIndex = i * 4;

      rgbaBytes[byteIndex] = grey;
      rgbaBytes[byteIndex + 1] = grey;
      rgbaBytes[byteIndex + 2] = grey;
      rgbaBytes[byteIndex + 3] = 255;
    }
    return rgbaBytes;
  }

  static List<int> readImageDimension(Uint8List wavBytes) {
    ByteData data = wavBytes.buffer.asByteData();

    for (int i = 0; i < wavBytes.length - 4; i++) {
      if (wavBytes[i] == 73 &&
          wavBytes[i + 1] == 77 &&
          wavBytes[i + 2] == 71 &&
          wavBytes[i + 3] == 70) {
        int width = data.getInt32(i + 8, Endian.little);
        int height = data.getInt32(i + 12, Endian.little);

        return [width, height];
      }
    }
    throw Exception("IMGF chunk not found");
  }
}
