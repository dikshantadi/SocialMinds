import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String? uid;
  Database({this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  Future createUserDocument(String userName, email) async {
    await userCollection.doc(uid).set({
      'userName': userName,
      'email': email,
    });
  }

  Future getUserData(String uid) async {
    DocumentSnapshot sp = await userCollection.doc(uid).get();
    return sp;
  }
}
