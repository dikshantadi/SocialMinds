import 'package:flutter/material.dart';

import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:curved_navigation_bar_with_label/nav_custom_painter.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class homepg extends StatelessWidget {
  const homepg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurpleAccent,
        color: Colors.deepPurpleAccent,
        buttonBackgroundColor: Colors.white,
        items: [
          CurvedNavigationBarItem(
            icon: Icon(
              Iconsax.home,
              size: 30,
              color: Colors.black,
            ),
            label: "Home",
          ),
          CurvedNavigationBarItem(
              icon: Icon(
                Iconsax.message,
                size: 30,
                color: Colors.black,
              ),
              label: "Chat"),
          CurvedNavigationBarItem(
              icon: Icon(Iconsax.camera, size: 30, color: Colors.black),
              label: "Camera"),
          CurvedNavigationBarItem(
              icon: Icon(
                Iconsax.search_normal,
                size: 30,
                color: Colors.black,
              ),
              label: "Search"),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
      body: Container(color: Colors.white),
    );
  }
}
