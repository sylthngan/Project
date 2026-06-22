class UserModel {
  final String uid;
  final String fullName;
  final String birthday;
  final String email;
  final String avatar;
  final String phone;
  final String location;
  final bool isLandlord;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.birthday,
    required this.email,
    required this.avatar,
    required this.phone,
    required this.location,
    required this.isLandlord,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      fullName: data["fullName"] ?? "",
      birthday: data["birthday"] ?? "",
      email: data["email"] ?? "",
      avatar: data["avatar"] ?? "",
      phone: data["phone"] ?? "",
      location: data["location"] ?? "",
      isLandlord: data["isLandlord"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "birthday": birthday,
      "email": email,
      "avatar": avatar,
      "phone": phone,
      "location": location,
      "isLandlord": isLandlord,
    };
  }
}