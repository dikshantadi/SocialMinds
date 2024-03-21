import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socialmind/Widgets/Custom_scaffold.dart';
import 'package:socialmind/Widgets/buttom.dart';

class Welcomepg extends StatelessWidget {
  const Welcomepg({super.key});

  @override
  Widget build(BuildContext context) {
    return Custom_scaffold(
      child: Column(
        children: [
          Flexible(
              child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 40.0,
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(children: [
                  TextSpan(
                      text: "Welcome to \n",
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: "SocialMind: A Simple Social Media",
                      style: TextStyle(
                        fontSize: 20,
                        height: 2,
                      ))
                ]),
              ),
            ),
          )),
          Flexible(
              child: Row(
            children: [
              WelcomeButton(),
              WelcomeButton(),
            ],
          ))
        ],
      ),
    );
  }
}
