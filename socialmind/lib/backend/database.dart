import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String? uid;
  Database({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection("Posts");

  Future<void> createUserDocument(String userName, email) async {
    try {
      Map<String, dynamic> userData = {
        'userName': userName,
        'email': email,
        'profilePicture': '',
        'friendList': [],
        'postList': []
      };
      print(userData);

      await userCollection.doc(uid).set(userData);
    } catch (e) {
      print(e);
    }
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
}
