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
      _search();
    });
  }

  void _search() async {
    if (_searchQuery.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot results =
          await DatabaseService().searchByUsername(_searchQuery);
      print(results.docs[0]['email']);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    }
  }

  void _sendFriendRequest(String userId) async {
    await DatabaseService().sendFriendRequest(userId);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Friend request sent')));
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
                      title: Text(user['username']),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:socialmind/backend/database.dart';

// class Search extends StatefulWidget {
//   const Search({super.key});

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   bool _isLoading = false;
//   String? userName;
//   QuerySnapshot? snapshot;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: Text("Search Page"),
//         actions: [
//           Container(
//             width: 300,
//             child: TextField(
//                 decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       search();
//                     },
//                     icon: Icon(Icons.search),
//                   ),
//                   hintText: 'Search for friends',
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     _isLoading = true;
//                     userName = value;
//                   });
//                   search();
//                 }),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : snapshot == null
//               ? Center(child: Text('Search for friends'))
//               : ListView.builder(
//                   itemCount: snapshot!.docs.length,
//                   itemBuilder: (context, index) {
//                     var user = snapshot!.docs[index];
//                     return ListTile(
//                       title: Text(user['userName']),
//                       subtitle: Text(user['email']),
//                       trailing: ElevatedButton(
//                         onPressed: () {
//                           print('sent');
//                         },
//                         child: Text('Add Friend'),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }

//   search() async {
//     await Database(uid: FirebaseAuth.instance.currentUser!.uid)
//         .searchUserByName(userName!)
//         .then((value) {
//       if (value != null) {
//         setState(() {
//           _isLoading = false;
//           snapshot = value;
//           print(snapshot!.docs[0]['email']);
//         });
//       }
//     });
//   }
// }
