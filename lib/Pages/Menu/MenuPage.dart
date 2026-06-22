import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Pages/Menu/PersonalPage/1_PersonalPage.dart';
import 'package:rental_room/Pages/Menu/2_ProfilePage.dart';
import 'package:rental_room/Pages/Menu/3_AccountPage.dart';
import 'package:rental_room/Pages/Menu/4_ContractPage.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

import '../../Model/Post.dart';
import '../../Model/User.dart';

class Menupage extends StatefulWidget {
  const Menupage({super.key});

  @override
  State<Menupage> createState() => _Menupage();
}

class _Menupage extends State<Menupage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Detail 1
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseAuth.instance.currentUser == null
                  ? null
                  : FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),

              builder: (context, snapshot) {

                if (FirebaseAuth.instance.currentUser == null) {
                  return const SizedBox();
                }

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                bool isLandlord = data["isLandlord"] ?? false;

                if (!isLandlord) {
                  return Detail1();
                }

                return GestureDetector(
                  onTap: () async {
                    final firebaseUser = FirebaseAuth.instance.currentUser;
                    if (firebaseUser == null) return;

                    final userDoc = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(firebaseUser.uid)
                        .get();

                    UserModel userModel = UserModel.fromMap(
                      userDoc.data()!,
                      userDoc.id,
                    );

                    final postSnapshot = await FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: firebaseUser.uid)
                        .get();

                    List<PostModel> posts = postSnapshot.docs.map((doc) {
                      return PostModel.fromMap(doc.data());
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonalPage(
                          user: userModel,
                          posts: posts,
                        ),
                      ),
                    );
                  },
                  child: Detail1(),
                );
              },
            ),
            SizedBox(height: 5),
            //Detail2
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 20.0, 0, 5),
              child: Text(
                'Detail Information',
                style: Text_Button_Styles.text5,
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage()));
                    },
                    child: ListTile(
                      leading: Icon(
                          Icons.account_circle,
                          color: colorsyle.text3,
                          size: 20
                      ),
                      title: Text(
                          'Profile Information',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(
                          Icons.navigate_next,
                          color: colorsyle.text3,
                          size: 18
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>AccountPage()));

                    },
                    child: ListTile(
                      leading: Icon(
                          Icons.lock_person,
                          color: colorsyle.text3,
                          size: 20
                      ),
                      title: Text(
                          'Account Information',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(
                          Icons.navigate_next,
                          color: colorsyle.text3,
                        size: 18
                      ),
                    ),
                  ),
                  GestureDetector( 
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> ContractPage()));
                    },
                    child: ListTile(
                      leading: Icon(
                          Icons.description,
                          color: colorsyle.text3,
                          size: 20
                      ),
                      title: Text(
                          'Contract Information',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(
                          Icons.navigate_next,
                          color: colorsyle.text3,
                          size: 18
                      ),
                    ),
                  ),
                  // Change to landlord
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      bool isLandlord = data["isLandlord"] ?? false;

                      if(isLandlord){
                        return const SizedBox();
                      }

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: isLandlord,
                              onChanged: (value) async {
                                if(value == true){
                                  bool? confirm = await showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                        title: const Text(
                                          "Become a landlord",
                                        ),
                                        content: const Text(
                                          "After enabling landlord mode, you can create rental posts and manage rooms.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context, false);
                                            },
                                            child: Text(
                                                "Cancel",
                                              style: Text_Button_Styles.text4,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context, true);
                                            },
                                            child: Text(
                                                "Confirm",
                                              style: Text_Button_Styles.text4,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if(confirm != true){
                                    return;
                                  }
                                }

                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  "isLandlord": value,
                                });
                              },

                              secondary: Icon(
                                Icons.home_work,
                                color: colorsyle.text3,
                                size: 20
                              ),
                              title: Text(
                                "Normal User Mode",
                                style: Text_Button_Styles.text3,
                              ),

                              subtitle: Text(
                                "Turn on to become a landlord to create rental post",
                                style: Text_Button_Styles.text4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Spacer(),

            Center(
              child: OutlinedButton(
                  onPressed: () async{
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                      'Log out',
                    style: Text_Button_Styles.text3
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Detail1() {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      return Text("User haven't logged in");
    }
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(user.uid).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 15),
                    Text('Data is loading')
                  ],
                ),
              ),
            );
          }
          if(snapshot.hasError){
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Error: ${snapshot.error}')
                    ]
                ),
              ),
            );
          }
          if(!snapshot.hasData || !snapshot.data!.exists){
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 15),
                    Text('No data')
                  ],
                ),
              ),
            );
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;

          String name = data["fullName"] ?? "";
          String email = data["email"] ?? "";
          String avt = data["avatar"] ?? "";

          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: avt.isNotEmpty? Container(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        avt,
                      ),
                    ),
                  ):Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: colorsyle.primary
                    ),
                    child: Center(
                      child: Icon(
                        Icons.perm_identity_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          name.isNotEmpty? name : "Name haven't updated",
                          style: Text_Button_Styles.text6
                      ),
                      Text(
                        email.isNotEmpty? email : "Email haven't updated",
                        style: Text_Button_Styles.text5,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
