import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:socialmind/Frontend/StartPage.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/backend/authentication.dart';

class verifyEmail extends StatefulWidget {
  final String email;
  final String password;
  const verifyEmail({super.key, required this.email, required this.password});

  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  bool _isLoading = false;
  Authentication auth = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.blue),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInUp(
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 1500),
                      child: Text(
                        "Hello, an email has been sent to you. Please verify your email and click verify",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    FadeInUp(
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 1500),
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
                          onPressed: () {
                            verify();
                          },
                          height: 45,
                          minWidth: double.maxFinite,
                          color: Colors.black,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Verify"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FadeInUp(
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 1500),
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
                          onPressed: () {
                            deleteAccount();
                          },
                          height: 45,
                          minWidth: double.maxFinite,
                          color: Colors.black,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("Go back"),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }

  deleteAccount() async {
    setState(() {
      _isLoading = true;
    });
    await auth.deleteAccount(widget.email).then((value) {
      if (value == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StartPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
          backgroundColor: Colors.red,
        ));
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  verify() async {
    setState(() {
      _isLoading = true;
    });
    await auth.verify().then((value) {
      print(value);
      if (value == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email has been verified"),
          backgroundColor: Colors.green,
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepg()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email hasn't been verified yet"),
          backgroundColor: Colors.red,
        ));
      }
    });
    setState(() {
      _isLoading = false;
    });
  }
}
