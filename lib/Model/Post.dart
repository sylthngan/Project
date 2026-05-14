class PostModel {
  final String postId;
  final String uid;
  final String title;
  final String description;
  final String type;
  final double price;

  final double lat;
  final double lng;

  final List<dynamic> images;

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

  PostModel({
    required this.postId,
    required this.uid,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
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
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      uid: map['uid'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      price: (map['price'] ?? 0).toDouble(),
      lat: (map['lat'] ?? 0).toDouble(),
      lng: (map['lng'] ?? 0).toDouble(),
      images: map['images'] ?? [],
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'title': title,
      'description': description,
      'type': type,
      'price': price,
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
    };
  }
}
