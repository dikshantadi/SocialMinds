import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class pg2 extends StatelessWidget {
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
              child: Lottie.asset('assets/Animation - 1710935099608.json',
                  height: 350, width: 350),
            ),
          ),
          SizedBox(
              height: 20), // to adjust the space between the animation ra text
          const Text(
            'Share your feelings and posts \n When and where ever you are',
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
