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
      "createdAt": FieldValue.serverTimestamp(),
    });

    return user;
  }

  Future<User?> login(String email, String password) async {
    UserCredential result =
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }
}