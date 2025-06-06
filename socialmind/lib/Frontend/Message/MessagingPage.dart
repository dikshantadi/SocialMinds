import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmind/Frontend/Message/ChatPage.dart';
import 'package:socialmind/Frontend/landingPage.dart';
import 'package:socialmind/Frontend/nav.dart';

class MessagingPage extends StatefulWidget {
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  bool _isLoading = true;
  List<DocumentSnapshot> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Fetch friendships where currentUser is either user1 or user2
      QuerySnapshot friendsSnapshot1 = await FirebaseFirestore.instance
          .collection('friendships')
          .where('user1', isEqualTo: currentUser.uid)
          .get();

      QuerySnapshot friendsSnapshot2 = await FirebaseFirestore.instance
          .collection('friendships')
          .where('user2', isEqualTo: currentUser.uid)
          .get();

      setState(() {
        _friends = [...friendsSnapshot1.docs, ...friendsSnapshot2.docs];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // borderRadius: BorderRadius.vertical(
              //   bottom: Radius.circular(20),
              // ),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => landingPage(index: 0)));
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _friends.isEmpty
              ? Center(child: Text('No friends found'))
              : ListView.separated(
                  itemCount: _friends.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 2,
                  ),
                  itemBuilder: (context, index) {
                    var friend = _friends[index];
                    var friendId = friend['user1'] ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? friend['user2']
                        : friend['user1'];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(friendId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          var data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return ListTile(
                            tileColor: Colors.grey[200],
                            hoverColor: Colors.grey[400],
                            leading: CircleAvatar(child: Icon(Icons.person)),
                            title: Text(data['userName']),
                            subtitle: Text(data['email']),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    friendId: friendId,
                                    friendName: data['userName']),
                              ),
                            ),
                          );
                        }
                        return ListTile(
                          leading: Icon(Icons.person),
                          trailing: CircularProgressIndicator(),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
