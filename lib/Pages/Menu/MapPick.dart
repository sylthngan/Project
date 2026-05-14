import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Pages/Menu/CityPick.dart';
import 'package:rental_room/style/color.dart';
import '../../style/myTextField.dart';

class LocationAdd extends StatefulWidget {
  const LocationAdd({super.key});

  @override
  State<LocationAdd> createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd> {
  final user = FirebaseAuth.instance.currentUser;

  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  Future<void> update() async {
    try {
      final street = streetController.text.trim();
      final city = cityController.text.trim();
      final location = street.isNotEmpty ? "$street, $city" : city;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "location": location,
      });
      if (!mounted) return;

      Navigator.pop(context, location);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated Successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update Failed: $e")),
      );
    }
  }

  @override
  void dispose() {
    streetController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Set Location',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            myTextField(
              label: "Street",
              controller: streetController,
              isPass: false,
            ),

            const SizedBox(height: 15),

            myTextField(
              label: "City",
              controller: cityController,
              isPass: false,
              readOnly: true,
              suffixIcon: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CityPick()),
                );

                if (result is String) {
                  setState(() {
                    cityController.text = result;
                  });
                }
              },
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:colorsyle.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(18),
                  ),
                ),
                onPressed: update,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}