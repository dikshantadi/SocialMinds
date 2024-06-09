import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmind/Frontend/Userpage/Userpg.dart';
import 'package:socialmind/Frontend/homepg.dart';
import 'package:socialmind/Widgets/comment.dart';
import 'package:socialmind/backend/database.dart';
import 'package:socialmind/backend/storage.dart';
import 'package:timeago/timeago.dart' as timeago;

class postTemplate extends StatefulWidget {
  final String postID;
  final String authorName;
  final String imageUrl;
  final String caption;
  final int time;
  final String authorID;
  const postTemplate(
      {super.key,
      required this.authorID,
      required this.postID,
      required this.authorName,
      required this.caption,
      required this.imageUrl,
      required this.time});

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
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
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
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return comment(
                    type: "Post",
                    authorID: widget.authorID,
                    postID: widget.postID,
                    postedBy: widget.authorName,
                    imageUrl: widget.imageUrl,
                    caption: widget.caption);
              }));
            },
            contentPadding: EdgeInsets.all(10),
            title: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Userpg(uid: widget.authorID);
                }));
              },
              child: Text(
                widget.authorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
            subtitle: Text(
                '${timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.time))}'),
            trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          alignment: AlignmentDirectional.bottomCenter,
                          actions: [
                            // FirebaseAuth.instance.currentUser!.uid ==
                            //         widget.authorID
                            //     ? ListTile(
                            //         onTap: () {},
                            //         title: Text('edit'),
                            //         leading: Icon(Icons.edit),
                            //       )
                            //     : SizedBox(
                            //         height: 0,
                            //       ),
                            ListTile(
                              onTap: () {
                                sharePost();
                              },
                              title: Text("Share Post"),
                              leading: Icon(Icons.share),
                            ),
                            FirebaseAuth.instance.currentUser!.uid ==
                                    widget.authorID
                                ? ListTile(
                                    onTap: () {
                                      deletePost();
                                    },
                                    leading: Icon(Icons.delete),
                                    title: Text(
                                      'Delete Post',
                                      style: TextStyle(fontSize: 17),
                                    ))
                                : SizedBox(
                                    height: 0,
                                  ),
                          ],
                        );
                      });
                }),
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
            height: 300, // Set a fixed height for the placeholder
            width: double.infinity, // Make the placeholder take the full width
            color: Colors.grey[200], // Light grey color for the placeholder
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.contain,
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
                liked
                    ? ElevatedButton.icon(
                        label: Text('liked ${likesNo ?? 0}'),
                        onPressed: () {
                          removeLike();
                        },
                        icon: Icon(Icons.thumb_up),
                      )
                    : ElevatedButton.icon(
                        onPressed: () {
                          addLike();
                        },
                        icon: Icon(Icons.thumb_up),
                        label: Text('Like ${likesNo ?? 0}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Background color
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return comment(
                          type: "Post",
                          postID: widget.postID,
                          authorID: widget.authorID,
                          postedBy: widget.authorName,
                          imageUrl: widget.imageUrl,
                          caption: widget.caption);
                    }));
                  },
                  icon: Icon(Icons.comment),
                  label: Text('${commentNo ?? 0}'),
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

  removeLike() async {
    setState(() {
      liked = false;
      likesNo = likesNo! - 1;
    });
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .removeLikes(widget.postID)
        .then((value) {
      if (value == null) {
        print("liked deleted");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  deletePost() async {
    await Storage().deleteImage(widget.imageUrl);
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .deletePost(widget.postID)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text('Post Deleted')));
    });

    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => Homepg())));
  }

  sharePost() async {
    try {
      await Database(uid: FirebaseAuth.instance.currentUser!.uid)
          .sharePost(widget.postID)
          .then((value) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Post has been shared')));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text('Error')));
      print(e);
    }
  }
}
