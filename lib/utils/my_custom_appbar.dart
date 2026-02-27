import 'package:convert_io/constants/constant.dart';
import 'package:flutter/material.dart';

class MyCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const MyCustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 26,
          color: tertiary,
          fontFamily: "monospace",
          letterSpacing: 3,
        ),
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      backgroundColor: secondary,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
