import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Friend/FindFriendPage.dart';
import 'package:socialmind/Frontend/Login/Signup.dart';
import 'package:socialmind/Frontend/Login/verifyEmail.dart';
import 'package:socialmind/Frontend/StartPage.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/Frontend/test.dart';
import 'package:socialmind/backend/database.dart';
import 'Frontend/Login/verifyEmail.dart';
import 'package:socialmind/firebase_options.dart';
import 'package:socialmind/shared_preferences.dart';
import 'package:socialmind/Frontend/landingPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/*class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}*/

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getLoginStatus();
    deleteStories();
    super.initState();
  }

  deleteStories() async {
    try {
      await Database().deleteStories();
    } catch (e) {
      print(e);
    }
  }

  bool _loggedIn = false;
  getLoginStatus() async {
    await SP.getLoginStatus().then((value) {
      if (value != null) {
        setState(() {
          _loggedIn = value;
          print(value);
        });
      } else {
        setState(() {
          _loggedIn = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _loggedIn
            ? landingPage(
                index: 0,
              )
            : StartPage());
  }
}
