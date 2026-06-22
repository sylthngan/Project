import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Pages/Chat/ChatInboxPage.dart';
import 'package:rental_room/Pages/Home/HomePage.dart';
import 'package:rental_room/Pages/Map/LocationPage.dart';
import 'package:rental_room/Pages/Menu/MenuPage.dart';
import 'package:rental_room/Pages/Menu/PersonalPage/1_PersonalPage.dart';
import 'package:rental_room/style/color.dart';

import '../Model/Post.dart';
import '../Model/User.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}
class _BottomnavigationState extends State<Bottomnavigation> {

  int indexSelected = 0;

  UserModel? currentUser;
  List<PostModel> myPosts = [];

  List<Widget> _pages = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    final postSnap = await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: uid)
        .get();

    final userModel = UserModel.fromMap(userDoc.data()!, userDoc.id);

    final posts = postSnap.docs.map((e) {
      final data = e.data();
      data['postId'] = e.id;
      return PostModel.fromMap(data);
    }).toList();

    setState(() {
      currentUser = userModel;
      myPosts = posts;

      _pages = [
        const HomePage(),
        const MapPage(),
        ChatInboxPage(),
        PersonalPage(user: currentUser!, posts: myPosts),
        const Menupage(),
      ];

      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    if (isLoading || currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: indexSelected,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colorsyle.primary,
        unselectedItemColor: colorsyle.textPrimary,
        currentIndex: indexSelected,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            indexSelected = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 20),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded, size: 20),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment, size: 20),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 20),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, size: 20),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}