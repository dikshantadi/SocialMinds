import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class pg1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform.translate(
            offset: const Offset(0, -110),
            child: Transform.scale(
              scale: 0.8,
              child: Lottie.asset('assets/Socialmedia.json',
                  height: 350, width: 350),
            ),
          ),
          SizedBox(
              height:
                  20), // Adjust the space between the animation and the text
          const Text(
            'Welcome to SocialMind\n A simple social media',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
      backgroundColor: Colors.white,
    ));
  }
}
