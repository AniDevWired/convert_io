import 'dart:io';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:convert_io/constants/constant.dart';
import 'package:convert_io/engine/wav_decoder_image_engine.dart';
import 'package:convert_io/utils/my_custom_appbar.dart';
import 'package:convert_io/utils/my_custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DecoderPage extends StatefulWidget {
  const DecoderPage({super.key});

  @override
  State<DecoderPage> createState() => _DecoderPageState();
}

class _DecoderPageState extends State<DecoderPage> {
  File? _audioFile;
  final player = AudioPlayer();
  bool isPlaying = false;
  bool isProcessing = false;
  ui.Image? _decodedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppbar(title: "DECODER"),
      backgroundColor: surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // pick btn -->
                MyCustomButton(text: "Pick Wav File", onTap: pickZaAudioFile),

                SizedBox(height: 16),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _audioFile != null
                          ? _audioFile!.path
                          : "No Audio is selected.\nHere the selected audio path will be shown.",
                      style: TextStyle(fontSize: 16, fontFamily: "monospace", color: tertiary),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // play btn -->
                MyCustomButton(
                  text: "Play Audio",
                  onTap: _audioFile == null ? null : playAudio,
                ),

                SizedBox(height: 16),

                // stop btn -->
                MyCustomButton(text: "Stop Audio", onTap: stopAudio),

                SizedBox(height: 16),

                // decode btn -->
                MyCustomButton(
                  text: "Decode Audio",
                  onTap: _audioFile == null || isProcessing
                      ? null
                      : decodeZaAudio,
                ),

                SizedBox(height: 16),

                // preview thingy -->
                SizedBox(
                  height: 300,
                  width: 300,
                  child: _decodedImage == null
                      ? Center(
                          child: Text("Noo decoded image", style: TextStyle(fontSize: 18, fontFamily: "monospace", color: tertiary)),
                        )
                      : RawImage(image: _decodedImage, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickZaAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );
    if (result != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> playAudio() async {
    if (_audioFile == null) return;

    await player.play(DeviceFileSource(_audioFile!.path));

    setState(() {
      isPlaying = true;
    });
  }

  Future<void> stopAudio() async {
    await player.stop();

    setState(() {
      isPlaying = false;
    });
  }

  Future<void> decodeZaAudio() async {
    if (_audioFile == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      ui.Image img = await WavDecoderImageEngine.wavToGreyScale(_audioFile!);
      setState(() {
        _decodedImage = img;
      });
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }
}
