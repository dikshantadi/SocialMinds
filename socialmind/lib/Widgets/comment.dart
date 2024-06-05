import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/backend/database.dart';
import 'package:socialmind/shared_preferences.dart';
import 'package:socialmind/Frontend/homepg.dart';

class comment extends StatefulWidget {
  final postID;
  final postedBy;
  final imageUrl;
  final caption;
  const comment(
      {super.key,
      required this.postID,
      required this.postedBy,
      required this.imageUrl,
      required this.caption});

  @override
  State<comment> createState() => _commentState();
}

class _commentState extends State<comment> {
  TextEditingController _commentController = TextEditingController();
  String? userName;
  QuerySnapshot? commentSnapshot;
  bool _beingPosted = false;
  @override
  void initState() {
    getComments();
    super.initState();
  }

  getComments() async {
    await SP.getUserName().then((value) {
      if (value != null) {
        setState(() {
          userName = value;
        });
      }
    });
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getComments(widget.postID)
        .then((value) {
      if (value != null) {
        setState(() {
          commentSnapshot = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepg()));
          },
        ),
        title: Text('Comments'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
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
                    widget.postedBy,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      widget
                          .postedBy[0], // Display the first letter of the name
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    widget.caption,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    postComment();
                  },
                  child: Text('Post'),
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
          commentSnapshot == null
              ? Text('No comments')
              : _beingPosted
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: commentSnapshot!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(commentSnapshot!.docs[index]
                                  ['commentorName'][0]),
                            ),
                            title: Text(
                                commentSnapshot!.docs[index]['commentorName']),
                            subtitle:
                                Text(commentSnapshot!.docs[index]['comment']),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }

  postComment() async {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _beingPosted = true;
      });
      Map<String, dynamic> commentData = {
        'commentorID': FirebaseAuth.instance.currentUser!.uid,
        'commentorName': userName,
        'comment': _commentController.text.trim(),
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      await Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .addCommentOnaPost(widget.postID, commentData)
          .then((value) {
        getComments();
      });
      setState(() {
        _commentController.clear();
        _beingPosted = false;
      });
    } else {
      print("Comment cannot be empty");
    }
  }
}
