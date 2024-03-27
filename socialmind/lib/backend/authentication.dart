import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class Authentication {
  final firebaseAuth = FirebaseAuth.instance;
  Future registerWithEmail(
      String userName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await Database(uid: user.uid).createUserDocument(userName, email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
