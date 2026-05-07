import 'package:flutter/material.dart';
import 'package:rental_room/style/color.dart';

class Searchbar extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final List<String> choice;
  final int selectedIndex;
  final Function(int) onChanged;

  Searchbar({
    required this.searchController,
    required this.choice,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(15,0,15,0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "Search Place...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(choice.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(choice[index]),
                          selected: selectedIndex == index,
                          selectedColor:colorsyle.primary,
                          labelStyle: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (_) => onChanged(index),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Icon(Icons.sort),
            ],
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}