import 'package:flutter/material.dart';

class Custom_scaffold extends StatelessWidget {
  const Custom_scaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurpleAccent,
              Colors.pinkAccent,
              Colors.blueAccent,
            ],
          ),
        ),
        child: SafeArea(
          child: child!,
        ),
      ),
    );
  }
}
