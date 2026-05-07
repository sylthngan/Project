import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Login/Login.dart';
import 'package:rental_room/Pages/BottomNavigation.dart';
import 'package:rental_room/Pages/Home/HomePage.dart';

class Checkauth extends StatelessWidget {
  const Checkauth({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Scaffold(
            body: Bottomnavigation(),
          );
        } else {
          return const Scaffold(
            body: Center(
                child: Login(),

            ),
          );
        }
      },
    );
  }
}