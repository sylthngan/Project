import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/Post.dart';

class PostService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createPost(PostModel post) async {
    try {
      print("CREATE POST CLICKED");
      print("Writing posts collection...");

      await firestore
          .collection('posts')
          .doc(post.postId)
          .set(post.toMap());

      print("posts success");
      print("AFTER POSTS");

      print("Writing my_posts collection...");

      await firestore
          .collection('users')
          .doc(post.uid)
          .collection('my_posts')
          .doc(post.postId)
          .set(post.toMap());
      print("AFTER MY_POSTS");
      print("my_posts success");

    } catch (e) {
      print("POST SERVICE ERROR: $e");
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getPosts({
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot snapshot = await query.get();

    List<PostModel> posts = snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return {
      'posts': posts,
      'lastDocument': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    };
  }

  Stream<List<PostModel>> getAllPosts() {
    return firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data()))
        .toList());
  }

  Stream<List<PostModel>> getPostsByType(String type) {
    return firestore
        .collection('posts')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data()))
        .toList());
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('my_posts')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data()))
        .toList());
  }
}