class AddressModel {
  String street;
  String city;
  String district;
  String ward;

  AddressModel({
    required this.street,
    required this.city,
    required this.district,
    required this.ward,
  });

  String get fullAddress =>
      "$street, $ward, $district, $city";
}