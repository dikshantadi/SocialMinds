import 'package:flutter/material.dart';
import 'dart:math';

class backgd extends StatelessWidget {
  const backgd({super.key, required Scaffold child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 469,
            width: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(132),
              color: Colors.green.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
