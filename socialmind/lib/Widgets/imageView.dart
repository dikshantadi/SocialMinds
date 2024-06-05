import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmind/Frontend/homepg.dart';

class imageView extends StatelessWidget {
  final String imageUrl;
  const imageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepg()));
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(),
            title: Text('title'),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Image.network(imageUrl),
          )
        ],
      ),
    );
  }
}
