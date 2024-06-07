import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';
import 'package:socialmind/backend/database.dart';
import 'package:socialmind/shared_preferences.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:timeago/timeago.dart' as timeago;

class comment extends StatefulWidget {
  final authorID;
  final String type;
  final postID;
  final postedBy;
  final imageUrl;
  final caption;
  const comment(
      {super.key,
      required this.authorID,
      required this.type,
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
        .getComments(widget.postID, widget.type)
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
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Userpg(uid: widget.authorID)));
                    },
                    child: Text(
                      widget.postedBy,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
                    widget.caption ?? '',
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
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
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
          commentSnapshot == null || commentSnapshot!.docs.length == 0
              ? Text('No comments')
              : _beingPosted
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: commentSnapshot!.docs.length,
                        separatorBuilder: (context, index) {
                          return Container(
                            color: Color.fromARGB(255, 255, 255, 255),
                            height: 5,
                            width: double.infinity,
                          );
                        },
                        itemBuilder: (context, index) {
                          final time = commentSnapshot!.docs[index]['time'];
                          return ListTile(
                            leading: CircleAvatar(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Userpg(
                                              uid: commentSnapshot!.docs[index]
                                                  ['commentorID'])));
                                },
                                child: Text(commentSnapshot!.docs[index]
                                    ['commentorName'][0]),
                              ),
                            ),
                            title: Text(
                              commentSnapshot!.docs[index]['commentorName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(commentSnapshot!.docs[index]['comment']),
                                SizedBox(height: 4),
                                Text(
                                  timeago.format(
                                    DateTime.fromMillisecondsSinceEpoch(time),
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
          .addCommentOnaPost(widget.postID, commentData, widget.type)
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
