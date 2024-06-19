import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/Camera/Camerapage.dart';
import 'package:socialmind/Frontend/Chat/Chatpage.dart';
import 'package:socialmind/Frontend/Message/ChatPage.dart';
import 'package:socialmind/Frontend/Message/MessagingPage.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';
import 'package:socialmind/Frontend/homepg.dart';

class Nav extends StatefulWidget {
  final index;
  const Nav({Key? key, required this.index}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  late int _currentIndex;
  final List<Widget> _pages = [
    Homepg(),
    Chat(),
    /* Camerapg(
      camera: firstcamera, cameras: [],
    ),*/
    Userpg(uid: FirebaseAuth.instance.currentUser!.uid),
  ];
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
        setState(() {
          _currentIndex = index;
        });
        // if (index == 0) {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => Homepg()));
        // } else if (index == 1) {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => MessagingPage()));
        // } else if (index == 2) {
        //   // Navigator.push(
        //   //     context, MaterialPageRoute(builder: (context) => CameraPage()));
        // } else if (index == 3) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               Userpg(uid: FirebaseAuth.instance.currentUser!.uid)));
        // } else {
        //   print("You noob");
        // }
      },
    );
  }
}
