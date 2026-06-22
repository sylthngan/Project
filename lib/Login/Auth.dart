import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> register({
    required String email,
    required String password,
    required String fullName,
    required String birthday,
    required String phone,
  }) async {
    UserCredential result =
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;

    await db.collection("users").doc(user!.uid).set({
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "birthday": birthday,
      "avatar": "",
      "location": "",
      "isLandlord": false,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return user;
  }

  Future<User?> login(String email, String password) async {

    try {
      UserCredential result =
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {

      if(e.code == 'user-not-found'){
        throw 'Email does not exist';
      }
      if(e.code == 'wrong-password'){
        throw 'Wrong password';
      }
      if(e.code == 'invalid-email'){
        throw 'Invalid email';
      }
      throw 'Login failed';
    }
  }
}