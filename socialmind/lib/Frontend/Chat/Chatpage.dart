import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:socialmind/Frontend/nav.dart';

class Chat extends StatelessWidget {
  const Chat({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                //gradient affect app bar lai
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepOrangeAccent,
                  Colors.deepPurpleAccent,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // curve appbar ko
              ),
            ),
          ),
          title: Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0 * 2.5),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Search Messages",
                hintText: "Search",
                prefixIcon: Icon(
                  Iconsax.search_normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Nav(), //nav bar taneko
    );
  }
}
