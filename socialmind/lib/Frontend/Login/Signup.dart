import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmind/Frontend/Login/Login.dart';
import 'package:socialmind/Frontend/Login/verifyEmail.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/Frontend/landingPage.dart';
import 'package:socialmind/Widgets/Custom_scaffold.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import '../../backend//authentication.dart';
import '../../shared_preferences.dart';
import '../../backend/database.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Authentication auth = Authentication();
  String? userName;
  String? email;
  String? password;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  int activeIndex = 0;
  final List<String> _images = ['assets/Chatbot.json'];
  late Timer _timer;

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

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator(
            backgroundColor: Colors.red,
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Sign Up'),
              titleTextStyle: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
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
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                          delay: Duration(milliseconds: 800),
                          duration: Duration(milliseconds: 1500),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                userName = value;
                              });
                            },
                            validator: (value) {
                              return value!.length != 0
                                  ? null
                                  : "This field cannot be empty";
                            },
                            decoration: InputDecoration(
                                labelText: "Username",
                                hintText: "Username",
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: Icon(
                                  Iconsax.user,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          )),
                      SizedBox(
                        height: 40,
                      ),
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
                                hintText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          )),
                      SizedBox(
                        height: 40,
                      ),
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
                              return value!.length > 8
                                  ? null
                                  : "Password must be 8 letters long";
                            },
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                labelText: "Password",
                                hintText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: Icon(
                                  Iconsax.key,
                                  color: Colors.black,
                                  size: 18,
                                ),
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
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade200, width: 2),
                                    borderRadius: BorderRadius.circular(10)),
                                floatingLabelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          )),
                      FadeInUp(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        child: Container(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              register();
                            },
                            height: 45,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Colors.black,
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 800),
                        duration: Duration(milliseconds: 1500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      await auth
          .registerWithEmail(userName!.trim(), email!.trim(), password!)
          .then((value) async {
        if (value == null) {
          final uid = await auth.firebaseAuth.currentUser!.uid;
          await SP.setLogInStatus(true);
          await SP.setEmail(email!);
          await SP.setUserName(userName);
          await Database(uid: auth.firebaseAuth.currentUser!.uid)
              .getUserData()
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
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      verifyEmail(email: email!, password: password!)));
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => landingPage(index: 0)));
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value),
            backgroundColor: Colors.red,
          ));
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Inputs'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
