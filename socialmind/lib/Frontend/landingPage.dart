import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/Camera/Camerapage.dart';
import 'package:socialmind/Frontend/Message/MessagingPage.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/backend/database.dart';

class landingPage extends StatefulWidget {
  final int index;
  const landingPage({Key? key, required this.index}) : super(key: key);

  @override
  State<landingPage> createState() => _NavState();
}

class _NavState extends State<landingPage> {
  late int _currentIndex;
  String? userName;
  final List<Widget> _pages = [
    Homepg(),
    MessagingPage(),
    CameraPage(),
    Userpg(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    getUserData();
  }

  getUserData() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserData()
        .then((value) {
      DocumentSnapshot snapshot = value;
      setState(() {
        userName = snapshot['userName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
        },
      ),
    );
  }
}
