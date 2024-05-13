import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/Widgets/Custom_scaffold.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/Login/Forgotpassword.dart';
import 'package:socialmind/Frontend/Login/Signup.dart';
import 'package:socialmind/backend/authentication.dart';
import 'package:socialmind/backend/database.dart';
import '../../shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int activeIndex = 0;
  Authentication auth = Authentication();
  final formKey = GlobalKey<FormState>();
  String? email;
  String? password;
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
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
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
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {},
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
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) {
                      if (value!.length <= 8) {
                        return "password has to be 8 characters";
                      } else {
                        return null;
                      }
                    },
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()));
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
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepOrangeAccent,
                          Colors.deepPurpleAccent,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      // onPressed: () {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => Homepg()));
                      // },
                      onPressed: () {
                        login();
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
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
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      await auth.loginWithEmail(email!, password!).then((value) async {
        if (value == null) {
          final uid = await auth.firebaseAuth.currentUser!.uid;
          await SP.setLogInStatus(true);
          await SP.setEmail(email!);
          await Database(uid: auth.firebaseAuth.currentUser!.uid)
              .getUserData(uid)
              .then(
            (value) async {
              if (value != null) {
                DocumentSnapshot snapshot = value;
                await SP.setUserName(snapshot['userName']);
              }
            },
          );

          print(uid);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homepg()));
        } else {
          print(value);
        }
      });
    }
  }
}
