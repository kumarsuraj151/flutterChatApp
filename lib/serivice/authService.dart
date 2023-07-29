import 'package:chatapp/helper/Shared_prefrence.dart';
import 'package:chatapp/serivice/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  Future login(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // call our database service to update the database
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // print(e);
      return e.message;
    }
  }

  //register
  Future register(String name, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        // call our database service to update the database
        await DatabaseSerivce(uid: user.uid).updateUserData(name, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // print(e);
      return e.message;
    }
  }

  // logout

  Future logout() async {
    try {
      await HeperFunction.saveUserLoggedIn(false);
      await HeperFunction.saveUserName("");
      await HeperFunction.saveUserEmail("");
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      // print(e);
      return e.message;
    }
  }
}
