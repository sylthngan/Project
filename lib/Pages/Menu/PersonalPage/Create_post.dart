import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  String category = 'House';

  bool ac = false;
  bool washer = false;
  bool fan = false;
  bool fridge = false;
  bool bed = false;

  int bedrooms = 1;

  List<File> images = [];

  double lat = 0;
  double lng = 0;

  Future<void> pickImages() async {
    final picker = ImagePicker();

    final picked = await picker.pickMultiImage();

    setState(() {
      images = picked.map((e) => File(e.path)).toList();
    });
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();

    lat = position.latitude;
    lng = position.longitude;
  }

  Future<void> createPost() async {
    await getLocation();

    final id = const Uuid().v4();

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(id)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'title': titleController.text,
      'description': descriptionController.text,
      'category': category,
      'price': double.parse(priceController.text),
      'latitude': lat,
      'longitude': lng,
      'street': 'Street',
      'ward': 'Ward',
      'district': 'District',
      'city': 'City',
      'images': [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85'
      ],
      'bedrooms': bedrooms,
      'airConditioner': ac,
      'washingMachine': washer,
      'fan': fan,
      'refrigerator': fridge,
      'bed': bed,
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: category,
              items: const [
                DropdownMenuItem(
                  value: 'House',
                  child: Text('House'),
                ),
                DropdownMenuItem(
                  value: 'Room',
                  child: Text('Room'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Price',
              ),
            ),

            const SizedBox(height: 15),

            if (category == 'House')
              Row(
                children: [
                  const Text('Bedrooms'),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        bedrooms--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(bedrooms.toString()),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        bedrooms++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

            switchItem('Air Conditioner', ac, (v) => setState(() => ac = v)),
            switchItem('Washing Machine', washer,
                    (v) => setState(() => washer = v)),
            switchItem('Fan', fan, (v) => setState(() => fan = v)),
            switchItem('Refrigerator', fridge,
                    (v) => setState(() => fridge = v)),
            switchItem('Bed', bed, (v) => setState(() => bed = v)),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: createPost,
              child: const Text('Create'),
            )
          ],
        ),
      ),
    );
  }

  Widget switchItem(
      String title,
      bool value,
      Function(bool) onChanged,
      ) {
    return SwitchListTile(
      value: value,
      title: Text(title),
      onChanged: onChanged,
    );
  }
}
