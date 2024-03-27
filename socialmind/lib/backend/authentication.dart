import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final firebaseAuth = FirebaseAuth.instance;
  Future registerWithEmail(
      String userName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
