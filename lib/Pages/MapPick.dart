import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {

  LatLng selectedLocation = LatLng(16.4637, 107.5909); // Huế
  String address = "";

  Future<void> getAddress(LatLng pos) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);

    final place = placemarks.first;

    setState(() {
      address =
      "${place.street}, ${place.locality}, ${place.country}";
    });
  }

  @override
  void initState() {
    super.initState();
    getAddress(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
      ),
      body: Stack(
        children: [

          // 🔥 MAP
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 15,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
                getAddress(point);
              },
            ),
            children: [

              // 🔹 TILE (OpenStreetMap)
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),

              // 🔹 MARKER
              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 🔥 ADDRESS BOX
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Text(address),
            ),
          ),

          // 🔥 CONFIRM BUTTON
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, address);
              },
              child: const Text("Confirm Location"),
            ),
          )
        ],
      ),
    );
  }
}