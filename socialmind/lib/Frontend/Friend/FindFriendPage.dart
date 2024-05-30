import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmind/backend/friend_database_service.dart';

class FindFriendsPage extends StatefulWidget {
  @override
  _FindFriendsPageState createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  QuerySnapshot? _searchResults;

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
    _search();
  }

  void _search() async {
    if (_searchQuery.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        print("Initiating search with query: $_searchQuery");
        QuerySnapshot results = await DatabaseService().searchByUsername(_searchQuery);
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
        print("Search results count: ${_searchResults?.docs.length}");
        _searchResults?.docs.forEach((doc) {
          print("Found user: ${doc.data()}");
        });
      } catch (e) {
        print("Error during search: $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sendFriendRequest(String userId) async {
    print("Sending friend request to $userId");
    await DatabaseService().sendFriendRequest(userId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Friend request sent')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Friends'),
        backgroundColor: Colors.orange,
        actions: [
          Container(
            width: 300,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
                hintText: 'Search for friends',
              ),
              onChanged: (value) => _onSearchChanged(),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults == null
              ? Center(child: Text('Search for friends'))
              : ListView.builder(
                  itemCount: _searchResults!.docs.length,
                  itemBuilder: (context, index) {
                    var user = _searchResults!.docs[index];
                    return ListTile(
                      title: Text(user['userName']),
                      subtitle: Text(user['email']),
                      trailing: ElevatedButton(
                        onPressed: () => _sendFriendRequest(user.id),
                        child: Text('Add Friend'),
                      ),
                    );
                  },
                ),
    );
  }
}
