import 'package:flutter/material.dart';

import '../constants/constant.dart';

class MyCustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyCustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "monospace",
              fontSize: 16,
              letterSpacing: 3,
              color: tertiary
            ),
          ),
        ),
      ),
    );
  }
}
