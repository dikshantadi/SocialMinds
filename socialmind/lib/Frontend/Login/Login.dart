import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/Widgets/Custom_scaffold.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/Login/Forgotpassword.dart';
import 'package:socialmind/Frontend/Login/Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int activeIndex = 0;
  final List<String> _images = [
    'assets/Smd.json',
    'assets/Social net.json',
    'assets/Social Network.json',
  ];

  late Timer _timer;

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        activeIndex++;
        if (activeIndex == _images.length) activeIndex = 0;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 50),
              FadeInUp(
                child: Container(
                  height: 350,
                  child: Stack(
                    children: _images.asMap().entries.map((e) {
                      return Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          duration: Duration(seconds: 1),
                          opacity: activeIndex == e.key ? 1 : 0,
                          child: Lottie.asset(e.value, height: 400),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 40),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Email or Username",
                    prefixIcon: Icon(Iconsax.user, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: TextField(
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Password",
                    prefixIcon: Icon(Iconsax.key, size: 18),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 18,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                     },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homepg()));
                  },
                  height: 45,
                  minWidth: double.infinity,
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Login"),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
