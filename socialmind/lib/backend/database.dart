import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialmind/backend/storage.dart';

class Database {
  final String? uid;
  Database({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection("Posts");
  final CollectionReference storyCollection =
      FirebaseFirestore.instance.collection("Story");

  Future<void> createUserDocument(String userName, email) async {
    try {
      Map<String, dynamic> userData = {
        'userName': userName,
        'email': email,
        'profilePicture': '',
        'friendList': [],
        'postList': [],
        'storyList': []
      };
      print(userData);

      await userCollection.doc(uid).set(userData);
    } catch (e) {
      print(e);
    }
  }

  Future updateAddressandBirthday(Map<String, dynamic> data) async {
    try {
      DocumentReference ref = await userCollection.doc(uid);
      ref.update({'birthDay': data['birthday'], 'address': data['address']});
    } catch (e) {}
  }

  Future deleteUser(String email) async {
    try {
      QuerySnapshot snapshot =
          await userCollection.where('email', isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        await userCollection.doc(snapshot.docs[0].id).delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future getUserData() async {
    DocumentSnapshot sp = await userCollection.doc(uid).get();
    return sp;
  }

  Future uploadPostByUser(Map<String, dynamic> postData) async {
    DocumentReference document = await postCollection.add(postData);
    await Database(uid: uid).userCollection.doc(uid).update({
      'postList': FieldValue.arrayUnion(["${document.id}"])
    });
  }

  Future getPosts() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      List friendList = doc['friendList'];
      QuerySnapshot snapshot =
          await postCollection.where('authorID', whereIn: friendList).get();
      return snapshot;
    } catch (e) {
      print(e);
    }
  }

  Future getMyPost() async {
    try {
      DocumentSnapshot snapshot = await userCollection.doc(uid).get();
      List posts = [];
      for (int i = 0; i < snapshot['postList'].length; i++) {
        await postCollection.doc(snapshot['postList'][i]).get().then((value) {
          posts.add(value);
        });
      }
      return posts;
    } catch (e) {
      print(e);
    }
  }

  Future addCommentOnaPost(String postID, Map<String, dynamic> commentData,
      String collection) async {
    try {
      if (collection == 'Post') {
        await postCollection
            .doc(postID)
            .collection("Comments")
            .add(commentData);
      } else {
        await storyCollection
            .doc(postID)
            .collection("Comments")
            .add(commentData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getComments(String postID, String collection) async {
    try {
      if (collection == 'Post') {
        QuerySnapshot snapshot = await postCollection
            .doc(postID)
            .collection("Comments")
            .orderBy('time', descending: true)
            .get();
        return snapshot;
      } else {
        QuerySnapshot snapshot = await storyCollection
            .doc(postID)
            .collection("Comments")
            .orderBy('time', descending: true)
            .get();
        return snapshot;
      }
    } catch (e) {
      print(e);
    }
  }

  Future addLikes(String postID, Map<String, dynamic> likeData) async {
    try {
      await postCollection.doc(postID).collection('likes').add(likeData);
    } catch (e) {
      print(e);
    }
  }

  Future removeLikes(String postID) async {
    try {
      await postCollection
          .doc(postID)
          .collection('likes')
          .where('likedBy', isEqualTo: uid)
          .get()
          .then((value) async {
        if (value.docs.length != 0) {
          DocumentReference ref = await postCollection
              .doc(postID)
              .collection('likes')
              .doc(value.docs[0]['likedBy']);
          ref.delete();
        }
      });
    } catch (e) {
      return e;
    }
  }

  Future getNumberOfLikesAndComment(postID) async {
    QuerySnapshot snapshot =
        await postCollection.doc(postID).collection('likes').get();
    final likes = snapshot.docs.length;
    QuerySnapshot commentSnapshot =
        await postCollection.doc(postID).collection('Comments').get();

    final comment = commentSnapshot.docs.length;

    QuerySnapshot likedStatusSp = await postCollection
        .doc(postID)
        .collection('likes')
        .where('likedBy', isEqualTo: uid)
        .get();
    if (likedStatusSp.docs.length == 0) {
      Map<String, dynamic> likeAndComment = {
        'likes': likes,
        'comments': comment,
        'likedByUser': false
      };
      return likeAndComment;
    } else {
      Map<String, dynamic> likeAndComment = {
        'likes': likes,
        'comments': comment,
        'likedByUser': true
      };
      return likeAndComment;
    }
  }

  Future uploadStory(Map<String, dynamic> story) async {
    try {
      DocumentReference doc = await storyCollection.add(story);
      await userCollection.doc(uid).update({
        'storyList': FieldValue.arrayUnion(['${doc.id}'])
      });
    } catch (e) {
      return e;
    }
  }

  Future getStories() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();

      QuerySnapshot snapshot = await storyCollection
          .where('authorID', whereIn: doc['friendList'])
          .get();
      return snapshot;
    } catch (e) {
      print(e);
    }
  }

  Future deleteStories() async {
    try {
      final dayInMilisecond = 86400000;
      final storiesToBeDeleted = await storyCollection
          .where('time',
              isLessThanOrEqualTo:
                  DateTime.now().millisecondsSinceEpoch - dayInMilisecond)
          .get();
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in storiesToBeDeleted.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      for (int i = 1; i <= storiesToBeDeleted.docs.length; i++) {
        String imageUrl = storiesToBeDeleted.docs[i]['imageUrl'];
        await Storage().deleteImage(imageUrl);
      }
    } catch (e) {
      print(e);
    }
  }

  Future deletePost(String postID) async {
    try {
      await postCollection.doc(postID).delete();
      DocumentReference ref = await userCollection.doc(uid);
      ref.update({
        'postList': FieldValue.arrayRemove(["${postID}"])
      });
    } catch (e) {
      print(e);
    }
  }

  Future sharePost(String postID) async {
    try {
      DocumentReference ref = await userCollection.doc(uid);
      ref.update({
        'postList': FieldValue.arrayUnion(["${postID}"])
      });
    } catch (e) {
      print(e);
    }
  }
}
