import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<Map<String, dynamic>> getUser(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    return doc.data() ?? {};
  }
}