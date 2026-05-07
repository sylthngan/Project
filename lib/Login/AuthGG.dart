import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGg {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
    await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential result =
    await auth.signInWithCredential(credential);

    User? user = result.user;

    if (user == null) return null;

    final doc = db.collection("users").doc(user.uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        "fullName": user.displayName ?? "",
        "email": user.email ?? "",
        "phone": user.phoneNumber,
        "birthday": "",
        "avatar": user.photoURL ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    return user;
  }
}