import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Model/Post.dart';
import 'package:rental_room/Pages/Home/SearchBar.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String avt = "";
  TextEditingController searchController = TextEditingController();

  Future<void> getUser_Avt() async {
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) return;

    final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    if (!mounted) return;

    setState(() {
      name = doc["fullName"] ?? "";
      avt = doc["avatar"] ?? "";

    });
  }
  @override
  void initState(){
    super.initState();
    getUser_Avt();
  }
  int selectedChoice = 0;
  List<String> _choice = [
    "House",
    "Room",
    "Villa"
  ];

  List<Post> _post = [
    Post(
      title: "Phòng trọ quận 1",
      subtile: "",
      img: "https://i.pinimg.com/736x/66/fe/49/66fe496bbf4d748b0b9e925bd7d5a9f3.jpg",
      price: 3000000,
      location: "HCM",
    ),
    Post(
      title: "Căn hộ mini",
      subtile: "",
      img: "https://i.pinimg.com/736x/66/fe/49/66fe496bbf4d748b0b9e925bd7d5a9f3.jpg",
      price: 4500000,
      location: "Hà Nội",
    ),
    Post(
      title: "Phòng giá rẻ",
      subtile: "",
      img: "https://i.pinimg.com/736x/66/fe/49/66fe496bbf4d748b0b9e925bd7d5a9f3.jpg",
      price: 2000000,
      location: "Đà Nẵng",
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                      SizedBox(height: 10),
                      //Introduce
                      Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          avt.isNotEmpty ?
                          Container(
                            padding: EdgeInsetsGeometry.all(5),
                            decoration: BoxDecoration(
                                color: colorsyle.primary,
                                borderRadius: BorderRadius.circular(30),
                            ),
                            child: CircleAvatar(
                              backgroundImage: avt.isNotEmpty? NetworkImage(avt):null,

                            ),

                          ): Container(
                            padding: EdgeInsetsGeometry.all(10),
                            decoration: BoxDecoration(
                                color: colorsyle.primary,
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                              child: avt.isEmpty
                                  ? Icon(Icons.perm_identity_rounded, color: Colors.white)
                                  : null,
                            ),

                          ),
                          Container(
                            padding: EdgeInsetsGeometry.fromLTRB(15,5, 15,5),
                            decoration: BoxDecoration(
                              color: colorsyle.primary,
                              border: Border.all(
                                color: colorsyle.primary
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),

                            child: Text(
                                name.isEmpty ? "Loading.." : name,
                                style: Text_Button_Styles.text1,
                            ),
                          ),
                          Spacer(),

                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Discover',
                        style: Text_Button_Styles.text2,
                      ),
                      Text(
                          'Your Perfect Space',
                        style: Text_Button_Styles.text2,
                      ),

                  ]
              ),
            ),
          ),
            SliverPersistentHeader(
              pinned: true,
              delegate: Searchbar(
                searchController: searchController,
                choice: _choice,
                selectedIndex: selectedChoice,
                onChanged: (index) {
                  setState(() {
                    selectedChoice = index;
                  });
                },
              ),
            ),

            // TITLE
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 0, 10),
                child: Text(
                  'Nearby',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // LIST
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final post = _post[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [

                          Positioned.fill(
                            child: Image.network(
                              post.img,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ),

                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Text(
                                "${post.price} VND",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 10,
                            left: 10,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  post.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                                    SizedBox(width: 5),
                                    Text(
                                      post.location,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
                childCount: _post.length,

              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
            ),
          ]
        ),
      ),
    );
  }
}
