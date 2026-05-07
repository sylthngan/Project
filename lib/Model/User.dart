class UserModel {
  final String uid;
  final String fullName;
  final String birthday;
  final String email;
  final String avatar;
  final String phone;
  final String location;
  UserModel({
    required this.uid,
    required this.fullName,
    required this.birthday,
    required this.email,
    required this.avatar,
    required this.phone,
    required this.location,
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
    };
  }
}