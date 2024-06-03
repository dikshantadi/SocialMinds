import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> searchByUsername(String username) async {
    print("Searching for username: $username");
    Query query = _firestore
        .collection('Users')
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
      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      final senderName = userDoc.data()?['userName'] ?? 'Unknown';

      print("Sending friend request from ${currentUser.uid} to $toUserId");
      await _firestore.collection('friendRequests').add({
        'from': currentUser.uid,
        'fromName': senderName,
        'to': toUserId,
        'status': 'pending',
        'message': '$senderName has sent you a friend request.',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<QuerySnapshot> getFriendRequests() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Fetching friend requests for ${currentUser.uid}");
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
      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      final acceptorName = userDoc.data()?['userName'] ?? 'Unknown';

      print("Accepting friend request $requestId from $fromUserId");
      await _firestore
          .collection('friendRequests')
          .doc(requestId)
          .update({'status': 'accepted'});
      await _firestore.collection('friendships').add({
        'user1': currentUser.uid,
        'user2': fromUserId,
        'message': '$acceptorName has accepted your friend request.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add users to each other's friend list
      try {
        await _firestore.collection('Users').doc(currentUser.uid).update({
          'friendList': FieldValue.arrayUnion([fromUserId])
        });
        await _firestore.collection('Users').doc(fromUserId).update({
          'friendList': FieldValue.arrayUnion([currentUser.uid])
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    print("Rejecting friend request $requestId");
    await _firestore
        .collection('friendRequests')
        .doc(requestId)
        .update({'status': 'rejected'});
  }

  Future<QuerySnapshot> getFriends() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Fetching friends for ${currentUser.uid}");
      return _firestore
          .collection('friendships')
          .where('user1', isEqualTo: currentUser.uid)
          .where('user2', isEqualTo: currentUser.uid)
          .get();
    }
    throw Exception('User not authenticated');
  }

  Future<String> getFriendshipStatus(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      QuerySnapshot sentRequests = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: currentUser.uid)
          .where('to', isEqualTo: userId)
          .get();

      if (sentRequests.docs.isNotEmpty) {
        return sentRequests
            .docs.first['status']; // Returns 'pending' or 'accepted'
      }

      QuerySnapshot receivedRequests = await _firestore
          .collection('friendRequests')
          .where('from', isEqualTo: userId)
          .where('to', isEqualTo: currentUser.uid)
          .get();

      if (receivedRequests.docs.isNotEmpty) {
        return receivedRequests
            .docs.first['status']; // Returns 'pending' or 'accepted'
      }

      QuerySnapshot friendships = await _firestore
          .collection('friendships')
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

  // Method to get notifications for the current user
  Future<QuerySnapshot> getNotifications() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print("Fetching notifications for ${currentUser.uid}");
      return _firestore
          .collection('friendRequests')
          .where('to', isEqualTo: currentUser.uid)
          .where('status', isEqualTo: 'pending')
          .get();
    }
    throw Exception('User not authenticated');
  }


   // Method to send a message to a friend
  Future<void> sendMessage(String friendId, String message) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _firestore.collection('friendships')
          .doc(_getFriendshipDocId(currentUser.uid, friendId))
          .collection('messages')
          .add({
        'sender': currentUser.uid,
        'receiver': friendId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Method to get a stream of messages between the current user and a friend
  Stream<QuerySnapshot> getMessagesStream(String friendId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return _firestore.collection('friendships')
          .doc(_getFriendshipDocId(currentUser.uid, friendId))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
    throw Exception('User not authenticated');
  }

  // Helper method to get the document ID for a friendship between two users
  String _getFriendshipDocId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0 ? '$userId1\_$userId2' : '$userId2\_$userId1';
  }  
}
