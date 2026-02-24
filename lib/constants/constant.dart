import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    // The deepest shade for the overall app surface
    surface: const Color.fromRGBO(55, 53, 62, 1),

    // The muted red for buttons and primary actions
    primary: const Color.fromRGBO(113, 90, 90, 1),

    // The medium grey for secondary UI like cards or sidebars
    secondary: const Color.fromRGBO(68, 68, 78, 1),

    // The light grey for high-contrast text and icons
    tertiary: const Color.fromRGBO(211, 218, 217, 1),

    // A lighter version of primary for 'on-primary' content
    inversePrimary: const Color.fromRGBO(211, 218, 217, 0.8),
  ),
);
