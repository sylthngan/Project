import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Pages/Menu/PersonalPage/1_PersonalPage.dart';
import 'package:rental_room/Pages/Menu/2_ProfilePage.dart';
import 'package:rental_room/Pages/Menu/3_AccountPage.dart';
import 'package:rental_room/Pages/Menu/4_ContractPage.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

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
        padding: const EdgeInsets.fromLTRB(10.0, 25, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Detail 1
            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PersonalPage()));
                },
              child: Detail1(),
            ),
            SizedBox(height: 15),
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
                      leading: Icon(Icons.account_circle, color: colorsyle.text3),
                      title: Text(
                          'Profile Information',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(Icons.navigate_next, color: colorsyle.text3),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>AccountPage()));

                    },
                    child: ListTile(
                      leading: Icon(Icons.lock_person, color: colorsyle.text3),
                      title: Text(
                          'Account Information',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(Icons.navigate_next, color: colorsyle.text3),
                    ),
                  ),
                  GestureDetector( 
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> ContractPage()));
                    },
                    child: ListTile(
                      leading: Icon(Icons.description, color: colorsyle.text3),
                      title: Text(
                          'Contract Information',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(Icons.navigate_next, color: colorsyle.text3),
                    ),
                  ),
                ],
              ),
            ),
            //Detail2
            Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 35.0, 0, 5),
              child: Text(
                'Others',
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
                    ListTile(
                      leading: Icon(Icons.location_on_rounded, color: colorsyle.text3),
                      title: Text(
                          'Location',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(Icons.navigate_next, color: colorsyle.text3),
                    ),
                    ListTile(
                      leading: Icon(Icons.language, color: colorsyle.text3),
                      title: Text(
                          'Language',
                        style: Text_Button_Styles.text3,
                      ),
                      trailing: Icon(Icons.navigate_next, color: colorsyle.text3),
                    ),
                  ],
                )
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
                      radius: 30,
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
                        size: 37,
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
