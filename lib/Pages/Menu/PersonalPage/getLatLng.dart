import 'package:geocoding/geocoding.dart';

Future<Map<String, double>> getLatLngFromAddress(String address) async {
  List<Location> locations = await locationFromAddress(address);

  if (locations.isNotEmpty) {
    return {
      "lat": locations.first.latitude,
      "lng": locations.first.longitude,
    };
  }

  return {
    "lat": 0,
    "lng": 0,
  };
}