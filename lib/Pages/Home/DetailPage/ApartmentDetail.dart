import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Pages/Chat/ChatPage.dart';
import 'package:rental_room/Pages/Home/DetailPage/ListImgPage.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

import '../../../Model/Post.dart';
import '../../Map/LocationPage.dart';

class ApartmentDetail extends StatefulWidget {
  final PostModel post;

  const ApartmentDetail({
    super.key,
    required this.post,
  });

  @override
  State<ApartmentDetail> createState() => _ApartmentDetailState();
}

class _ApartmentDetailState extends State<ApartmentDetail> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool get isLandlord => widget.post.uid == currentUserId;

  int currentImage = 0;
  bool isFavorite = false;
  final NumberFormat currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
  );

  List<Map<String, dynamic>> getFacilities(PostModel post) {
    return [
      if (post.airConditioner) {"icon": Icons.ac_unit, "label": "Air Conditioner"},
      if (post.fan) {"icon": Icons.mode_fan_off_outlined, "label": "Fan"},
      if (post.refrigerator) {"icon": Icons.kitchen, "label": "Fridge"},
      if (post.washingMachine) {"icon": Icons.local_laundry_service, "label": "Washing Machine"},
      if (post.waterHeater) {"icon": Icons.water_drop_outlined, "label": "Water Heater"},
      if (post.bed) {"icon": Icons.bed, "label": "Bed"},
      if (post.kitchen) {"icon": Icons.countertops, "label": "Kitchen"},
      if (post.parking) {"icon": Icons.local_parking, "label": "Parking"},
      if (post.elevator) {"icon": Icons.elevator, "label": "Elevator"},
      if (post.pool) {"icon": Icons.pool, "label": "Pool"},
      if (post.gym) {"icon": Icons.fitness_center, "label": "Gym"},
      if (post.wifi) {"icon": Icons.wifi, "label": "Wifi"},
      if (post.petAllowed) {"icon": Icons.pets, "label": "Pet Allowed"},
      if (post.balcony) {"icon": Icons.balcony, "label": "Balcony"},
      if (post.securityCamera) {"icon": Icons.videocam_outlined, "label": "Security"},
    ];
  }

  void _navigateToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPage(focusPost: widget.post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f5f5),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GalleryPage(
                            images: widget.post.images,
                            initialIndex: currentImage,
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 300,
                      child: CachedNetworkImage(
                        imageUrl: widget.post.images[currentImage],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 55,
                    left: 20,
                    child: Column(
                      children: [
                        _circleButton(
                          Icons.arrow_back,
                          () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              setState(() => isFavorite = !isFavorite);
                              int newFavorite = isFavorite ? widget.post.favorites + 1 : widget.post.favorites - 1;
                              await FirebaseFirestore.instance.collection("posts").doc(widget.post.postId).update({"favorites": newFavorite});
                            },
                            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                      child: Text("${currentImage + 1}/${widget.post.images.length}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -25),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(color: colorsyle.textPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                              child: Text('Apartment', style: TextStyle(color: colorsyle.textPrimary, fontWeight: FontWeight.bold)),
                            ),
                            Text(currency.format(widget.post.price), style: TextStyle(color: colorsyle.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(widget.post.title, style: Text_Button_Styles.text2),
                        const SizedBox(height: 30),
                        const Text('Description', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(widget.post.description, style: TextStyle(height: 1.8, color: Colors.grey.shade700)),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _infoItem(Icons.bed, '${widget.post.bedroom}', 'Beds'),
                            _infoItem(Icons.bathtub, '${widget.post.bathroom}', 'Bath'),
                            _infoItem(Icons.square_foot, '${widget.post.area}', 'm²'),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text('Facilities', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 15, runSpacing: 15,
                          children: getFacilities(widget.post).map((f) => _facility(f["icon"], f["label"])).toList(),
                        ),
                        const SizedBox(height: 40),
                        _locationCard(),
                        const SizedBox(height: 35),
                        GestureDetector(
                          onTap: _navigateToMap,
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
                            clipBehavior: Clip.antiAlias,
                            child: AbsorbPointer(
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(target: LatLng(widget.post.lat, widget.post.lng), zoom: 15),
                                zoomControlsEnabled: false,
                                markers: {Marker(markerId: MarkerId(widget.post.postId), position: LatLng(widget.post.lat, widget.post.lng))},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xfff0f0f0)))),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorsyle.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Review & Vote', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () async {
                  if (isLandlord) return;
                  try {
                    final userDoc = await FirebaseFirestore.instance.collection("users").doc(widget.post.uid).get();
                    if (!userDoc.exists) throw "Landlord not found";
                    final landlordData = userDoc.data()!;
                    final String landlordName = landlordData["fullName"] ?? "Landlord";
                    final String landlordAvatar = landlordData["avatar"] ?? "";

                    final currentUserDoc = await FirebaseFirestore.instance.collection("users").doc(currentUserId).get();
                    final currentUserData = currentUserDoc.data() ?? {};
                    final String currentName = currentUserData["fullName"] ?? "User";
                    final String currentAvatar = currentUserData["avatar"] ?? "";
                    
                    final chatId = _buildChatId(currentUserId, widget.post.uid);

                    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({
                      "users": [currentUserId, widget.post.uid],
                      "postId": widget.post.postId,
                      "updatedAt": FieldValue.serverTimestamp(),
                      "userInfos": {
                        currentUserId: {
                          "fullName": currentName,
                          "avatar": currentAvatar,
                        },
                        widget.post.uid: {
                          "fullName": landlordName,
                          "avatar": landlordAvatar,
                        }
                      }
                    }, SetOptions(merge: true));

                    if (!mounted) return;
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(
                      receiverId: widget.post.uid,
                      receiverName: landlordName,
                      receiverAvatar: landlordAvatar,
                      postId: widget.post.postId,
                    )));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: Container(
                  width: 55, height: 55,
                  decoration: BoxDecoration(color: colorsyle.primary, borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.chat, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _buildChatId(String a, String b) {
    final ids = [a, b];
    ids.sort();
    return ids.join("_");
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Icon(icon)),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: colorsyle.primary),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _facility(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(color: colorsyle.textPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: colorsyle.primary, size: 20), const SizedBox(width: 8), Text(text)]),
    );
  }

  Widget _locationCard() {
    return GestureDetector(
      onTap: _navigateToMap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black.withOpacity(0.06),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: colorsyle.textPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.location_on, color: colorsyle.primary),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location', style: Text_Button_Styles.text6),
                  const SizedBox(height: 5),
                  Text(
                    '${widget.post.street}, ${widget.post.district}, ${widget.post.city}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorsyle.primary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
