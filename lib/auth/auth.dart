import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await fireAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      print("user Created");
      AuthCredential authCredential = userCredential.credential;
      return authCredential;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await fireAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print("User LoggedIn: Success....!!!");
    AuthCredential authCredential = userCredential.credential;
    return authCredential;
  }
}
