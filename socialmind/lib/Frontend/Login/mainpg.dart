import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmind/Frontend/Login/Login.dart';
import 'package:socialmind/Frontend/Login/Signup.dart';
import 'package:socialmind/Widgets/Custom_scaffold.dart';
import 'package:socialmind/Widgets/buttom.dart';

class Welcomepg extends StatefulWidget {
  const Welcomepg({super.key});

  @override
  State<Welcomepg> createState() => _WelcomepgState();
}

class _WelcomepgState extends State<Welcomepg> {
  @override
  Widget build(BuildContext context) {
    return Custom_scaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
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
                          style: TextStyle(
                              fontSize: 45, fontWeight: FontWeight.w600)),
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
              flex: 8,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                        child: WelcomeButton(
                      buttonText: 'Sign In',
                      onTap: LoginPage(),
                      color: Colors.transparent,
                    )),
                    Expanded(
                        child: WelcomeButton(
                      buttonText: 'Sign Up',
                      onTap: Signup(),
                      color: Colors.white,
                    )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
