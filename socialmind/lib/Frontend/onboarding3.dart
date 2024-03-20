import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class pg3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Transform.translate(
            offset: const Offset(0, -125),
            child: Transform.scale(
              scale: 0.8,
              child:
                  Lottie.asset('assets/Chatbot.json', height: 350, width: 350),
            ),
          ),
          const SizedBox(
              height: 2), // Adjust the space between the animation and the text
          const Text(
            'Chat with our own designed AI Chat-Bot',
            style: TextStyle(
                fontSize: 18,
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
