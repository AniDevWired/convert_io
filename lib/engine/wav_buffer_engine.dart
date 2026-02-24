import 'dart:typed_data';
import 'dart:ui' as ui;

class WavBufferEngine {
  static Future<Uint8List> fromGreyScaleImageToWavBytes(
    ui.Image greyscaleImage,
  ) async {
    final byteData = await greyscaleImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );

    if (byteData == null) {
      throw Exception("Failed to extract raw rgba bytes");
    }

    final rgbaBytes = byteData.buffer.asUint8List();

    final audioSamples = convertPixelsToSamples(
      rgbaBytes,
      greyscaleImage.width,
      greyscaleImage.height,
    );

    return samplesToWavBuffer(audioSamples);
  }

  static Float32List convertPixelsToSamples(
    Uint8List rgbaBytes,
    int width,
    int height,
  ) {
    int totalPixelCount = width * height;

    Float32List samples = Float32List(totalPixelCount);

    for (int i = 0; i < totalPixelCount; ++i) {
      int byteIndex = i * 4;

      int grey = rgbaBytes[byteIndex];

      double sample = (grey / 255.0) * 2 - 1;

      samples[i] = sample;
    }

    return samples;
  }

  static Future<Uint8List> samplesToWavBuffer(Float32List audioSamples) async {
    int rate = 44100;

    int len = audioSamples.length;

    int dataSize = len * 2;

    BytesBuilder builder = BytesBuilder();

    // RIFF header
    builder.add("RIFF".codeUnits);
    builder.add(_int32(36 + dataSize));
    builder.add("WAVE".codeUnits);

    // Format block
    builder.add("fmt ".codeUnits);
    builder.add(_int32(16));
    builder.add(_int16(1)); // PCM
    builder.add(_int16(1)); // mono
    builder.add(_int32(rate));
    builder.add(_int32(rate * 2));
    builder.add(_int16(2));
    builder.add(_int16(16));

    // Data block
    builder.add("data".codeUnits);
    builder.add(_int32(dataSize));

    // Write audio samples
    for (int i = 0; i < len; i++) {
      double s = audioSamples[i].clamp(-1.0, 1.0);

      int intSample = (s * 32767).toInt();

      builder.add(_int16(intSample));
    }

    return builder.toBytes();
  }

  static Uint8List _int16(int value) {
    ByteData b = ByteData(2);
    b.setInt16(0, value, Endian.little);
    return b.buffer.asUint8List();
  }

  static Uint8List _int32(int value) {
    ByteData b = ByteData(4);
    b.setInt32(0, value, Endian.little);
    return b.buffer.asUint8List();
  }
}
