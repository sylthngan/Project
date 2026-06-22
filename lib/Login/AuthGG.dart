import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGg {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // 1. Khởi tạo GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // 2. Bắt đầu quá trình đăng nhập (mở hộp thoại chọn tài khoản)
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      // 3. Lấy thông tin xác thực từ tài khoản Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 4. Tạo credential để đăng nhập vào Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Đăng nhập vào Firebase bằng credential
      UserCredential result = await auth.signInWithCredential(credential);

      User? user = result.user;

      if (user == null) return null;

      // 6. Lưu hoặc cập nhật thông tin người dùng vào Firestore
      final doc = db.collection("users").doc(user.uid);
      final snapshot = await doc.get();

      if (!snapshot.exists) {
        await doc.set({
          "fullName": user.displayName ?? "",
          "email": user.email ?? "",
          "phone": user.phoneNumber ?? "",
          "birthday": "",
          "location": "",
          "avatar": user.photoURL ?? "",
          "isLandlord": false,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print("Google Sign In Error: $e");
      return null;
    }
  }
}
