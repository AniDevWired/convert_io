# ConvertIO

ConvertIO is a Flutter application that explores data conversion between visual and audio formats.

The application can:

- Convert images into sound
- Convert sound into images

This project demonstrates how digital information can be represented across different mediums by mapping pixel values to audio samples and reconstructing them back into visual data.

---

# Features

- 📷 Image → Sound
  
  - Reads pixel data from an image
  - Converts pixel intensity values into audio sample values
  - Generates a playable audio file

- 🔊 Sound → Image
  
  - Reads raw audio sample data
  - Maps amplitude values into pixel brightness
  - Reconstructs an image from audio signals

- ⚡ Built using Flutter for cross-platform support

---

# Download Application

You can download the compiled application from Google Drive:

Application (APK):
https://drive.google.com/file/d/1BqROMTJTtpppJPMezhOtccxGSy64XFIO/view?usp=drivesdk

---

Sample Output

Example audio generated from an image:

Sample Audio File:
https://drive.google.com/file/d/1s89FwhinvGZLotarmHsKxs2eNHWoOIQQ/view?usp=drivesdk

---

Installation (From Source)

1. Clone the repository

git clone https://github.com/AniDevWired/convert_io.git
cd convert_io

2. Install dependencies

flutter pub get

3. Run the project

flutter run

---

How It Works

Image → Sound

1. Load an image file
2. Extract pixel values from the image
3. Convert pixel intensities into audio sample data
4. Encode the samples into a playable audio file (e.g. WAV)

Sound → Image

1. Load an audio file
2. Read raw audio sample values
3. Map amplitude values to pixel brightness
4. Generate an image from reconstructed pixel data

---

Requirements

- Flutter SDK
- Dart
- Android Studio or VS Code
- Android device or emulator

---

Contributing

Contributions are welcome. Improvements to the conversion algorithms, UI, or performance are appreciated.

---

Author

AniDevWired

GitHub:
https://github.com/AniDevWired