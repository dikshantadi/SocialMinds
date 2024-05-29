import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/backend/database.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Social Minds'),
          leading: MaterialButton(
            child: Text("back"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Homepg();
              }));
            },
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                MaterialButton(
                    onPressed: () {
                      getPost();
                    },
                    child: const Text("Get Post")),
              ],
            ),
          ),
        ));
  }

  getPost() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getPosts()
        .then((value) {
      if (value != null) {
        print(value.docs[4]['caption']);
      } else {
        print("null");
      }
    });
  }
}
