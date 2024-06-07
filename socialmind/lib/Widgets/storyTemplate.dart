import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';

class StoryTemplate extends StatelessWidget {
  final String imageUrl;
  final String authorName;
  final String authorID;

  StoryTemplate(
      {required this.imageUrl,
      required this.authorName,
      required this.authorID});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(2),
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Userpg(uid: authorID)));
            },
            child: Text(
              authorName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
