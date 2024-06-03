// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatPage extends StatefulWidget {
//   final String friendId;
//   final String friendName;

//   ChatPage({required this.friendId, required this.friendName});

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) {
//       return;
//     }

//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       await _firestore.collection('friendships')
//           .doc(_getFriendshipDocId(currentUser.uid, widget.friendId))
//           .collection('messages')
//           .add({
//         'sender': currentUser.uid,
//         'receiver': widget.friendId,
//         'message': _messageController.text.trim(),
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       _messageController.clear();
//     }
//   }

//   String _getFriendshipDocId(String userId1, String userId2) {
//     return userId1.compareTo(userId2) < 0 ? '$userId1\_$userId2' : '$userId2\_$userId1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.friendName),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('friendships')
//                   .doc(_getFriendshipDocId(currentUser!.uid, widget.friendId))
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 var messages = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     var message = messages[index].data() as Map<String, dynamic>;
//                     var isMe = message['sender'] == currentUser.uid;

//                     return ListTile(
//                       title: Align(
//                         alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                           decoration: BoxDecoration(
//                             color: isMe ? Colors.deepOrangeAccent : Colors.deepPurpleAccent,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(
//                             message['message'],
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmind/backend/friend_database_service.dart'; // Update with your actual path

class ChatPage extends StatefulWidget {
  final String friendId;
  final String friendName;

  ChatPage({required this.friendId, required this.friendName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    await _databaseService.sendMessage(widget.friendId, _messageController.text.trim());
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.friendName),
      //   backgroundColor: Colors.deepPurpleAccent,
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepOrangeAccent,
                  Colors.deepPurpleAccent,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            widget.friendName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _databaseService.getMessagesStream(widget.friendId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data() as Map<String, dynamic>;
                    var isMe = message['sender'] == currentUser!.uid;

                    return ListTile(
                      title: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.deepOrangeAccent : Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message['message'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

