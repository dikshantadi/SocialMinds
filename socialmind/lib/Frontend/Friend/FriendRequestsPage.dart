
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmind/backend/friend_database_service.dart';

class FriendRequestsPage extends StatefulWidget {
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  bool _isLoading = true;
  QuerySnapshot? _friendRequests;

  @override
  void initState() {
    super.initState();
    _loadFriendRequests();
  }

  void _loadFriendRequests() async {
    QuerySnapshot requests = await DatabaseService().getFriendRequests();
    setState(() {
      _friendRequests = requests;
      _isLoading = false;
    });
  }

  void _acceptRequest(String requestId, String fromUserId) async {
    await DatabaseService().acceptFriendRequest(requestId, fromUserId);
    _loadFriendRequests();
  }

  void _rejectRequest(String requestId) async {
    await DatabaseService().rejectFriendRequest(requestId);
    _loadFriendRequests();
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
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          title: Text(
            'Friend Requests',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _friendRequests == null || _friendRequests!.docs.isEmpty
              ? Center(child: Text('No friend requests'))
              : ListView.builder(
                  itemCount: _friendRequests!.docs.length,
                  itemBuilder: (context, index) {
                    var request = _friendRequests!.docs[index];
                    return ListTile(
                      title: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('Users').doc(request['from']).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                            return Text(data['userName']); // Assuming userName is the field containing the username
                          }

                          return CircularProgressIndicator();
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _acceptRequest(request.id, request['from']),
                            child: Text('Accept'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent, // Button color for "Accept"
                              ),
                            
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _rejectRequest(request.id),
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent, // Button color for "Accept"
                              ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
