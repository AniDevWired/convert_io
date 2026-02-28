import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:convert_io/constants/constant.dart';
import 'package:convert_io/engine/wav_buffer_engine.dart';
import 'package:convert_io/utils/my_custom_appbar.dart';
import 'package:convert_io/utils/my_custom_button.dart';
import 'package:convert_io/utils/my_custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  String filePath = "";

  TextEditingController fileName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppbar(title: "ENCODER"),
      backgroundColor: surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // controls like cam and gal
                // cam -->
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        pickImageFromCam();
                      },
                      icon: Icon(Icons.camera_rounded),
                      iconSize: 45,
                      color: tertiary,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "CAMERA",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: "monospace",
                        letterSpacing: 2,
                        color: tertiary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // gal -->
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        pickImageFromGallery();
                      },
                      icon: Icon(Icons.image_rounded),
                      iconSize: 45,
                      color: tertiary,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "GALLERY",
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: "monospace",
                        letterSpacing: 2,
                        color: tertiary,
                      ),
                    ),
                  ],
                ),

                // image preview -->
                SizedBox(
                  height: 300,
                  width: 300,
                  child: _imageFile != null
                      ? Image.file(_imageFile!)
                      : Center(
                          child: Text(
                            "*No Image selected\n\n*Select image by pressing the camera icon\n\n*Select image by pressing gallery icon",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "monospace",
                              color: tertiary,
                            ),
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
                  child: _processedImage == null
                      ? Center(
                          child: Text(
                            "Convert image to see the grey scale output\n\nWrite the file name before saving",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "monospace",
                              color: tertiary,
                            ),
                          ),
                        )
                      : RawImage(image: _processedImage, fit: BoxFit.contain),
                ),
                SizedBox(height: 16),
                // play btn -->
                MyCustomButton(
                  text: "Play Audio",
                  onTap: wavBytes == null ? null : playAudio,
                ),

                SizedBox(height: 16),

                // stop btn -->
                MyCustomButton(text: "Stop Audio", onTap: stopAudio),

                SizedBox(height: 16),

                MyCustomTextField(
                  hintText: "Enter file name before saving",
                  obscureText: false,
                  controller: fileName,
                  enableSuggestions: false,
                ),

                SizedBox(height: 16),

                // save btn -->
                MyCustomButton(
                  text: "Save Audio",
                  onTap: wavBytes == null ? null : saveAudio,
                ),
              ],
            ),
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
      ui.Image processedImage = await GreyscaleEngine.applyGreyscale(
        _imageFile!,
      );

      wavBytes = await WavBufferEngine.fromGreyScaleImageToWavBytes(
        processedImage,
      );

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
    if (wavBytes == null) return;

    String name = fileName.text.trim();

    if (name.isEmpty) {
      name = "gugugaga.wav";
    }

    if (!name.endsWith(".wav")) {
      name = "$name.wav";
    }

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Choose where to save WAV',
      fileName: name,
      type: FileType.custom,
      allowedExtensions: ['wav'],
      bytes: wavBytes!,
    );

    final file = File(outputFile!);

    await file.writeAsBytes(wavBytes!);

    setState(() {
      filePath = file.path;
    });
  }

  Future<void> stopAudio() async {
    await player.stop();
  }
}
