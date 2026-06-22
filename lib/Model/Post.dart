import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {

  final String postId;
  final String uid;
  final String type;

  final String title;
  final String description;

  final double price;
  final double deposit;

  final double lat;
  final double lng;

  final List<String> images;

  final String street;
  final String ward;
  final String district;
  final String city;

  final int bedroom;
  final int bathroom;

  final double area;

  final bool airConditioner;
  final bool washingMachine;
  final bool refrigerator;
  final bool fan;
  final bool bed;
  final bool wifi;
  final bool kitchen;
  final bool parking;
  final bool elevator;
  final bool pool;
  final bool gym;
  final bool petAllowed;
  final bool balcony;
  final bool securityCamera;
  final bool waterHeater;

  final bool available;

  final String status;

  final int floor;
  final int maxPeople;

  final DateTime createdAt;
  final DateTime updatedAt;

  final int views;
  final int favorites;

  PostModel({
    required this.postId,
    required this.uid,
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    required this.deposit,
    required this.lat,
    required this.lng,
    required this.images,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    required this.bedroom,
    required this.bathroom,
    required this.area,
    required this.airConditioner,
    required this.washingMachine,
    required this.refrigerator,
    required this.fan,
    required this.bed,
    required this.wifi,
    required this.kitchen,
    required this.parking,
    required this.elevator,
    required this.pool,
    required this.gym,
    required this.petAllowed,
    required this.balcony,
    required this.securityCamera,
    required this.waterHeater,
    required this.available,
    required this.status,
    required this.floor,
    required this.maxPeople,
    required this.createdAt,
    required this.updatedAt,
    required this.views,
    required this.favorites,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      uid: map['uid'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      street: map['street'] ?? '',
      ward: map['ward'] ?? '',
      district: map['district'] ?? '',
      city: map['city'] ?? '',
      bedroom: map['bedroom'] ?? 0,
      bathroom: map['bathroom'] ?? 0,
      area: (map['area'] ?? 0).toDouble(),
      airConditioner: map['airConditioner'] ?? false,
      washingMachine: map['washingMachine'] ?? false,
      refrigerator: map['refrigerator'] ?? false,
      fan: map['fan'] ?? false,
      bed: map['bed'] ?? false,
      wifi: map['wifi'] ?? false,
      kitchen: map['kitchen'] ?? false,
      parking: map['parking'] ?? false,
      elevator: map['elevator'] ?? false,
      pool: map['pool'] ?? false,
      gym: map['gym'] ?? false,
      petAllowed: map['petAllowed'] ?? false,
      balcony: map['balcony'] ?? false,
      securityCamera: map['securityCamera'] ?? false,
      waterHeater: map['waterHeater'] ?? false,
      available: map['available'] ?? true,
      status: map['status'] ?? 'available',
      floor: map['floor'] ?? 0,
      maxPeople: map['maxPeople'] ?? 1,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      views: map['views'] ?? 0,
      favorites: map['favorites'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'type': type,
      'title': title,
      'description': description,
      'price': price,
      'deposit': deposit,
      'lat': lat,
      'lng': lng,
      'images': images,
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
      'bedroom': bedroom,
      'bathroom': bathroom,
      'area': area,
      'airConditioner': airConditioner,
      'washingMachine': washingMachine,
      'refrigerator': refrigerator,
      'fan': fan,
      'bed': bed,
      'wifi': wifi,
      'kitchen': kitchen,
      'parking': parking,
      'elevator': elevator,
      'pool': pool,
      'gym': gym,
      'petAllowed': petAllowed,
      'balcony': balcony,
      'securityCamera': securityCamera,
      'waterHeater': waterHeater,
      'available': available,
      'status': status,
      'floor': floor,
      'maxPeople': maxPeople,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'views': views,
      'favorites': favorites,
    };
  }
}