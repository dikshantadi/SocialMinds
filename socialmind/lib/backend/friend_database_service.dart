// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseService {
//   // Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Search for users by username
//   Future<QuerySnapshot> searchByUsername(String username) async {
//     return await _firestore
//         .collection('users')
//         .where('username', isGreaterThanOrEqualTo: username)
//         .where('username', isLessThanOrEqualTo: username + '\uf8ff')
//         .get();
//   }

//   // Send a friend request
//   Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
//     await _firestore.collection('friendRequests').add({
//       'from': fromUserId,
//       'to': toUserId,
//       'status': 'pending',
//     });
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> searchByUsername(String username) {
    print(username);
    return _firestore
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: username)
        .where('userName', isLessThanOrEqualTo: username + '\uf8ff')
        .get();
  }

  Future<void> sendFriendRequest(String toUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
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
      return _firestore
          .collection('friendRequests')
          .where('to', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .get();
    }
    throw Exception('User not authenticated');
  }

  Future<void> acceptFriendRequest(String requestId, String fromUserId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _firestore
          .collection('friendRequests')
          .doc(requestId)
          .update({'status': 'accepted'});
      await _firestore.collection('friendships').add({
        'user1': currentUser.uid,
        'user2': fromUserId,
      });
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    await _firestore
        .collection('friendRequests')
        .doc(requestId)
        .update({'status': 'rejected'});
  }

  Future<QuerySnapshot> getFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return _firestore
          .collection('friendships')
          .where('user1', isEqualTo: currentUser.uid)
          .where('user2', isEqualTo: currentUser.uid)
          .get();
    }
    throw Exception('User not authenticated');
  }
}
