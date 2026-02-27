import 'package:flutter/material.dart';

import '../constants/constant.dart';

class MyCustomTextField extends StatelessWidget {
  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final bool enableSuggestions;
  final FocusNode? focusNode;
  const MyCustomTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.enableSuggestions,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        style: TextStyle(
          color: tertiary,
          fontSize: 16,
          fontFamily: "monospace"
        ),
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: tertiary,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: secondary,
          filled: true,
          hintText: hintText,
          hintFadeDuration: Duration(milliseconds: 700),
          hintStyle: TextStyle(color: primary),
        ),
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        textAlign: TextAlign.center,
        cursorColor: tertiary,
      ),
    );
  }
}
