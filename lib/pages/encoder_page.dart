import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:convert_io/engine/wav_buffer_engine.dart';
import 'package:convert_io/utils/my_custom_appbar.dart';
import 'package:convert_io/utils/my_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../engine/greyscale_engine.dart';

class EncoderPage extends StatefulWidget {
  const EncoderPage({super.key});

  @override
  State<EncoderPage> createState() => _EncoderPageState();
}

class _EncoderPageState extends State<EncoderPage> {
  File? _imageFile;

  final _picker = ImagePicker();

  ui.Image? _processedImage;

  Uint8List? wavBytes;

  bool isProcessing = false;

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppbar(title: "ENCODER"),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // icons -->
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      pickImageFromCam();
                    },
                    icon: Icon(Icons.camera_rounded),
                    iconSize: 55,
                  ),
                  IconButton(
                    onPressed: () {
                      pickImageFromGallery();
                    },
                    icon: Icon(Icons.photo_album_rounded),
                    iconSize: 55,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // image preview -->
              SizedBox(
                height: 300,
                width: 300,
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : Text(
                        "No Image selected",
                        style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
              ),

              // convert button -->
              MyCustomButton(
                text: "CONVERT",
                onTap: isProcessing ? null : processImage,
              ),
              SizedBox(height: 16),
              // show audio -->
              SizedBox(
                height: 300,
                width: 300,
                child: RawImage(image: _processedImage, fit: BoxFit.contain),
              ),
              SizedBox(height: 16),
              // play btn
              MyCustomButton(text: "Play Audio", onTap: wavBytes == null ? null : playAudio),
              // save btn
              MyCustomButton(text: "Save audio", onTap: wavBytes == null ? null : saveAudio)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> pickImageFromCam() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> processImage() async {
    if (_imageFile == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      ui.Image processedImage = await GreyscaleEngine.applyGreyscale(_imageFile!);

      wavBytes = await WavBufferEngine.fromGreyScaleImageToWavBytes(processedImage);

      setState(() {
        _processedImage = processedImage;
        isProcessing = false;
      });
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> playAudio() async {
    await player.play(BytesSource(wavBytes!));
  }

  Future<void> saveAudio() async {
    final dir = await getExternalStorageDirectory();

    final file = File("${dir!.path}/output.wav");

    await file.writeAsBytes(wavBytes!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Audio saved to ${file.path}"),
      ),
    );
  }
}
