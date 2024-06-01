import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Widgets/comment.dart';
import 'package:socialmind/backend/database.dart';

class postTemplate extends StatefulWidget {
  final String postID;
  final String authorName;
  final String imageUrl;
  final String caption;
  const postTemplate(
      {super.key,
      required this.postID,
      required this.authorName,
      required this.caption,
      required this.imageUrl});

  @override
  State<postTemplate> createState() => _postTemplateState();
}

class _postTemplateState extends State<postTemplate> {
  @override
  void initState() {
    getlikeandcomment();
    super.initState();
  }

  int? likesNo;
  int? commentNo;
  bool liked = false;
  getlikeandcomment() async {
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getNumberOfLikesAndComment(widget.postID)
        .then((value) {
      if (value != null) {
        setState(() {
          likesNo = value['likes'];
          commentNo = value['comments'];
          liked = value['likedByUser'];
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              widget.authorName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                widget.authorName[0], // Display the first letter of the name
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              widget.caption,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            height: 200, // Set a fixed height for the placeholder
            width: double.infinity, // Make the placeholder take the full width
            color: Colors.grey[200], // Light grey color for the placeholder
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                likesNo == null ? Text('0') : Text('${likesNo}'),
                liked
                    ? ElevatedButton.icon(
                        label: Text('liked'),
                        onPressed: () {},
                        icon: Icon(Icons.thumb_up),
                      )
                    : ElevatedButton.icon(
                        onPressed: () {
                          addLike();
                        },
                        icon: Icon(Icons.thumb_up),
                        label: Text('Like'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Background color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                commentNo == null ? Text('0') : Text('${commentNo}'),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return comment(
                          postID: widget.postID,
                          postedBy: widget.authorName,
                          imageUrl: widget.imageUrl,
                          caption: widget.caption);
                    }));
                  },
                  icon: Icon(Icons.comment),
                  label: Text('Comment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  addLike() async {
    try {
      setState(() {
        liked = true;
        likesNo = likesNo! + 1;
      });
      Map<String, dynamic> likeData = {
        'likedBy': FirebaseAuth.instance.currentUser!.uid,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      await Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .addLikes(widget.postID, likeData);
    } catch (e) {
      print("error when trying to like");
    }
  }
}