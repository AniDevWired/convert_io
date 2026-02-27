import 'package:convert_io/constants/constant.dart';
import 'package:convert_io/pages/decoder_page.dart';
import 'package:convert_io/pages/encoder_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  List pages = const [EncoderPage(), DecoderPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: secondary,
        selectedItemColor: tertiary,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_rounded),
            label: "Encoder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_outline_rounded),
            label: "Decoder",
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
