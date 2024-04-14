import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/nav.dart';

class Userpg extends StatefulWidget {
  const Userpg({super.key});

  @override
  State<Userpg> createState() => _UserpgState();
}

class _UserpgState extends State<Userpg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Nav(),
    );
  }
}
