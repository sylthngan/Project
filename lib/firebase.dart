import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Future<void> seedPosts() async {

  final firestore = FirebaseFirestore.instance;
  final uuid = Uuid();

  final now = DateTime.now();

  final posts = [

    {
      "postId": uuid.v4(),
      "uid": "user_001",
      "type": "Apartment",

      "title": "Luxury Apartment Da Nang",
      "description": "Beautiful apartment near the beach",

      "price": 5500000.0,
      "deposit": 1000000.0,

      "lat": 16.0544,
      "lng": 108.2022,

      "images": [
        "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688",
        "https://images.unsplash.com/photo-1494526585095-c41746248156",
      ],

      "street": "123 Vo Nguyen Giap",
      "ward": "My An",
      "district": "Ngu Hanh Son",
      "city": "Da Nang",

      "bedroom": 2,
      "bathroom": 1,

      "area": 60.0,

      "airConditioner": true,
      "washingMachine": true,
      "refrigerator": true,
      "fan": true,
      "bed": true,
      "wifi": true,
      "kitchen": true,
      "parking": true,
      "elevator": true,
      "pool": false,
      "gym": false,
      "petAllowed": false,
      "balcony": true,
      "securityCamera": true,
      "waterHeater": true,

      "available": true,

      "status": "available",

      "floor": 5,
      "maxPeople": 3,

      "createdAt": Timestamp.fromDate(now),
      "updatedAt": Timestamp.fromDate(now),

      "views": 0,
      "favorites": 0,
    },

    {
      "postId": uuid.v4(),
      "uid": "user_002",
      "type": "Room",

      "title": "Cheap Room For Student",
      "description": "Cheap room near university",

      "price": 2200000.0,
      "deposit": 500000.0,

      "lat": 16.0678,
      "lng": 108.2208,

      "images": [
        "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
      ],

      "street": "45 Le Duan",
      "ward": "Hai Chau",
      "district": "Hai Chau",
      "city": "Da Nang",

      "bedroom": 1,
      "bathroom": 1,

      "area": 25.0,

      "airConditioner": false,
      "washingMachine": true,
      "refrigerator": false,
      "fan": true,
      "bed": true,
      "wifi": true,
      "kitchen": false,
      "parking": true,
      "elevator": false,
      "pool": false,
      "gym": false,
      "petAllowed": true,
      "balcony": false,
      "securityCamera": true,
      "waterHeater": true,

      "available": true,

      "status": "available",

      "floor": 1,
      "maxPeople": 2,

      "createdAt": Timestamp.fromDate(now),
      "updatedAt": Timestamp.fromDate(now),

      "views": 12,
      "favorites": 3,
    },

  ];

  for (var post in posts) {

    await firestore
        .collection('posts')
        .doc(post['postId'] as String)
        .set(post);

    await firestore
        .collection('users')
        .doc(post['uid'] as String)
        .collection('my_posts')
        .doc(post['postId'] as String)
        .set(post);
  }

  print('Seed Data Success');
}