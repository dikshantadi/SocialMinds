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
    try {
      QuerySnapshot requests = await DatabaseService().getFriendRequests();
      setState(() {
        _friendRequests = requests;
        _isLoading = false;
      });
      print("Friend requests loaded: ${_friendRequests?.docs.length}");
    } catch (e) {
      print("Error loading friend requests: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
      appBar: AppBar(
        title: Text('Friend Requests'),
        backgroundColor: Colors.orange,
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
                      title: Text(request['from']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _acceptRequest(request.id, request['from']),
                            child: Text('Accept'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _rejectRequest(request.id),
                            child: Text('Reject'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
