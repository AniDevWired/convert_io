import 'package:flutter/material.dart';

class MyCustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const MyCustomAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 26,
          color: Theme.of(context).colorScheme.tertiary,
          fontFamily: "monospace",
          letterSpacing: 3
        ),
      ),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20)
        )
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
