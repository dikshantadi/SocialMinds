
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> searchByUsername(String username) async {
    print("Searching for username: $username");
    Query query = _firestore.collection('Users')
        .where('userName', isGreaterThanOrEqualTo: username)
        .where('userName', isLessThanOrEqualTo: username + '\uf8ff');
    print("Constructed query: $query");

    QuerySnapshot result = await query.get();
    print("Search results count: ${result.docs.length}");
    for (var doc in result.docs) {
      print("User found: ${doc.data()}");
    }
    return result;
  }

  Future<void> sendFriendRequest(String toUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Sending friend request from ${currentUser.uid} to $toUserId");
      await _firestore.collection('friendRequests').add({
        'from': currentUser.uid,
        'to': toUserId,
        'status': 'pending',
      });
    }
  }

  Future<QuerySnapshot> getFriendRequests() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Fetching friend requests for ${currentUser.uid}");
      return _firestore.collection('friendRequests')
          .where('to', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .get();
    }
    throw Exception('User not authenticated');
  }

  Future<void> acceptFriendRequest(String requestId, String fromUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Accepting friend request $requestId from $fromUserId");
      await _firestore.collection('friendRequests').doc(requestId).update({'status': 'accepted'});
      await _firestore.collection('friendships').add({
        'user1': currentUser.uid,
        'user2': fromUserId,
      });
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    print("Rejecting friend request $requestId");
    await _firestore.collection('friendRequests').doc(requestId).update({'status': 'rejected'});
  }

  Future<QuerySnapshot> getFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Fetching friends for ${currentUser.uid}");
      return _firestore.collection('friendships')
          .where('user1', isEqualTo: currentUser.uid)
          .where('user2', isEqualTo: currentUser.uid)
          .get();
    }
    throw Exception('User not authenticated');
  }

  Future<String> getFriendshipStatus(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot sentRequests = await _firestore.collection('friendRequests')
          .where('from', isEqualTo: currentUser.uid)
          .where('to', isEqualTo: userId)
          .get();

      if (sentRequests.docs.isNotEmpty) {
        return sentRequests.docs.first['status']; // Returns 'pending' or 'accepted'
      }

      QuerySnapshot receivedRequests = await _firestore.collection('friendRequests')
          .where('from', isEqualTo: userId)
          .where('to', isEqualTo: currentUser.uid)
          .get();

      if (receivedRequests.docs.isNotEmpty) {
        return receivedRequests.docs.first['status']; // Returns 'pending' or 'accepted'
      }

      QuerySnapshot friendships = await _firestore.collection('friendships')
          .where('user1', isEqualTo: currentUser.uid)
          .where('user2', isEqualTo: userId)
          .get();

      if (friendships.docs.isNotEmpty) {
        return 'friends';
      }

      return 'none';
    }
    throw Exception('User not authenticated');
  }
}
