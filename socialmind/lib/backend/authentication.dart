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

  Future loginWithEmail(String email, password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future logout() async {
    try {
      firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future changePassword(oldPassword, newPassword) async {
    try {
      final credential = EmailAuthProvider.credential(
          email: firebaseAuth.currentUser!.email!, password: oldPassword);
      await firebaseAuth.currentUser!
          .reauthenticateWithCredential(credential)
          .then((value) async {
        await firebaseAuth.currentUser!.updatePassword(newPassword);
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
