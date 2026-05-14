import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Future<void> seedPosts() async {

  final firestore = FirebaseFirestore.instance;

  final uuid = Uuid();

  final posts = [

    {
      'postId': uuid.v4(),
      'uid': 'user_1',
      'title': 'Luxury Apartment',
      'description': 'Beautiful apartment in Da Nang',
      'type': 'Apartment',
      'price': 5000000,

      'lat': 16.0544,
      'lng': 108.2022,

      'images': [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688'
      ],

      'street': 'Nguyen Van Linh',
      'ward': 'Hai Chau',
      'district': 'Hai Chau',
      'city': 'Da Nang',

      'bedroom': 2,
      'bathroom': 1,
      'area': 80.0,

      'airConditioner': true,
      'washingMachine': true,
      'refrigerator': true,
      'fan': true,
      'bed': true,

      'createdAt': FieldValue.serverTimestamp(),
    },

    {
      'postId': uuid.v4(),
      'uid': 'user_2',
      'title': 'Modern House',
      'description': 'Modern house near beach',
      'type': 'House',
      'price': 12000000,

      'lat': 16.0678,
      'lng': 108.2208,

      'images': [
        'https://images.unsplash.com/photo-1494526585095-c41746248156'
      ],

      'street': 'Vo Nguyen Giap',
      'ward': 'My An',
      'district': 'Ngu Hanh Son',
      'city': 'Da Nang',

      'bedroom': 3,
      'bathroom': 2,
      'area': 150.0,

      'airConditioner': true,
      'washingMachine': true,
      'refrigerator': true,
      'fan': true,
      'bed': true,

      'createdAt': FieldValue.serverTimestamp(),
    },

    {
      'postId': uuid.v4(),
      'uid': 'user_3',
      'title': 'Cheap Room',
      'description': 'Cheap room for students',
      'type': 'Room',
      'price': 2500000,

      'lat': 16.0750,
      'lng': 108.2230,

      'images': [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85'
      ],

      'street': 'Le Duan',
      'ward': 'Thanh Khe',
      'district': 'Thanh Khe',
      'city': 'Da Nang',

      'bedroom': 1,
      'bathroom': 1,
      'area': 25.0,

      'airConditioner': false,
      'washingMachine': true,
      'refrigerator': false,
      'fan': true,
      'bed': true,

      'createdAt': FieldValue.serverTimestamp(),
    },
  ];

  for (var post in posts) {

    await firestore
        .collection('posts')
        .doc(post['postId'] as String)
        .set(post);
  }

  print('Seed Data Success');
}