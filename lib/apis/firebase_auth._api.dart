import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthApi {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  // NOTE: getUsers
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }
  // NOTE: signin 
  Future<void> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      // print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') { 
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') { 
        print('Wrong password provided for that user.');
      }
    }
  }
  // NOTE: signup
  Future<void> signUp(String email, String password) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
  // NOTE: signout
  Future<void> signOut() async {
    await auth.signOut();
  }
}