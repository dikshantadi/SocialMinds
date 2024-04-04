import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';

class Nav extends StatelessWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
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
          label: "Chat",
        ),
        CurvedNavigationBarItem(
          icon: Icon(
            Iconsax.camera,
            size: 30,
            color: Colors.black,
          ),
          label: "Camera",
        ),
        CurvedNavigationBarItem(
          icon: Icon(
            Iconsax.user,
            size: 30,
            color: Colors.black,
          ),
          label: "User",
        ),
      ],
      onTap: (index) {
        //Handle button tap
      },
    );
  }
}
