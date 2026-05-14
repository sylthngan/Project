import 'package:flutter/material.dart';
import 'package:rental_room/Pages/Chat/ChatPage.dart';
import 'package:rental_room/Pages/Home/HomePage.dart';
import 'package:rental_room/Pages/Map/LocationPage.dart';

import 'package:rental_room/Pages/Menu/MenuPage.dart';
import 'package:rental_room/style/color.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});
  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {

  int indexSelected = 0;

  final List<Widget> _pages = [HomePage(), MapPage(), Chatpage(),Menupage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[indexSelected],
      bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom > 0
          ? null
          : Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            selectedItemColor: colorsyle.primary,
            unselectedItemColor: colorsyle.textPrimary,
            currentIndex: indexSelected,
              onTap: (index){
                setState(() {
                  indexSelected = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                        Icons.home_filled,
                    ),
                  label: 'Home'
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.location_on_rounded,
                  ),
                  label: 'Location'
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.comment,
                    ),
                    label: 'Chat'
                ),

                 BottomNavigationBarItem(

                    icon: Icon(
                      Icons.menu,
                    ),
                   label: 'Menu'
                )
              ]
          ),
        ),
      ),
    );
  }
}
