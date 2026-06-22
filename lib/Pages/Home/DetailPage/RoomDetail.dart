import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

import '../../../Model/Post.dart';
import '../../Chat/ChatInboxPage.dart';
import '../../Chat/ChatPage.dart';
import '../../Map/LocationPage.dart';
import 'ListImgPage.dart';

class RoomDetail extends StatefulWidget {
  final PostModel post;

  const RoomDetail({
    super.key,
    required this.post,
  });

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool get isLandlord => widget.post.uid == currentUserId;
  int currentImage = 0;
  final NumberFormat currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
  );
  List<Map<String, dynamic>> getRoomUtilities(PostModel post) {
    return [
      if (post.airConditioner) {"icon": Icons.ac_unit, "label": "Air Conditioner"},
      if (post.wifi) {"icon": Icons.wifi, "label": "Wifi"},
      if (post.bed) {"icon": Icons.bed, "label": "Bed"},
      if (post.kitchen) {"icon": Icons.kitchen, "label": "Kitchen"},
      if (post.washingMachine) {"icon": Icons.local_laundry_service, "label": "Washer"},
      if (post.refrigerator) {"icon": Icons.kitchen_outlined, "label": "Fridge"},
      if (post.fan) {"icon": Icons.mode_fan_off_outlined, "label": "Fan"},
      if (post.parking) {"icon": Icons.local_parking, "label": "Parking"},
      if (post.elevator) {"icon": Icons.elevator, "label": "Elevator"},
      if (post.securityCamera) {"icon": Icons.videocam_outlined, "label": "Security"},
    ];
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
                    child: IgnorePointer(
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
                  ),

                  Positioned(
                    top: 55,
                    left: 20,

                    child: _circleButton(
                      Icons.arrow_back,
                          () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 25,
                    right: 20,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        "${currentImage + 1}/${widget.post.images.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: [

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),

                              decoration: BoxDecoration(
                                color: colorsyle.textPrimary.withOpacity(0.15),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),

                              child:  Text(
                                'Room',
                                style: TextStyle(
                                  color: colorsyle.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 10,
                              ),

                              decoration: BoxDecoration(
                                color: colorsyle.primary,
                                borderRadius:
                                BorderRadius.circular(20),
                              ),

                              child: Text(
                                currency.format(widget.post.price),
                                style:
                                Text_Button_Styles.text_button,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          widget.post.title,
                          style: Text_Button_Styles.text2,
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [

                            Icon(
                              Icons.location_on,
                              color: colorsyle.primary,
                              size: 18,
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                '${widget.post.street}, ${widget.post.district}, ${widget.post.city}',

                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Description',

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          widget.post.description,

                          style: TextStyle(
                            height: 1.8,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Wrap(
                          spacing: 30,
                          runSpacing: 20,
                          children: [

                            if(widget.post.bedroom > 0)
                              _infoItem(
                                Icons.bed,
                                '${widget.post.bedroom}',
                                'Bedroom',
                              ),

                            if(widget.post.bathroom > 0)
                              _infoItem(
                                Icons.bathtub,
                                '${widget.post.bathroom}',
                                'Bathroom',
                              ),

                            if(widget.post.kitchen)
                              _infoItem(
                                Icons.kitchen,
                                '1',
                                'Kitchen',
                              ),

                            if(widget.post.area > 0)
                              _infoItem(
                                Icons.square_foot,
                                '${widget.post.area}',
                                'm²',
                              ),
                          ],
                        ),
                        const SizedBox(height: 35),

                        const Text(
                          'Utilities',

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: getRoomUtilities(widget.post)
                              .map((e) => _utility(e["icon"], e["label"]))
                              .toList(),
                        ),
                        const SizedBox(height: 40),

                        _locationCard(),

                        const SizedBox(height: 35),

                        Container(
                          height: 220,

                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(28),
                          ),

                          clipBehavior: Clip.antiAlias,

                          child: GoogleMap(
                            initialCameraPosition:
                            CameraPosition(
                              target: LatLng(
                                widget.post.lat,
                                widget.post.lng,
                              ),
                              zoom: 15,
                            ),

                            zoomControlsEnabled: false,

                            markers: {
                              Marker(
                                markerId: MarkerId(
                                  widget.post.postId,
                                ),

                                position: LatLng(
                                  widget.post.lat,
                                  widget.post.lng,
                                ),
                              ),
                            },
                          ),
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),

          child: Row(
            children: [

              Expanded(
                child: Container(
                  height: 50,

                  decoration: BoxDecoration(
                    color: colorsyle.primary,
                    borderRadius:
                    BorderRadius.circular(22),
                  ),

                  child: Center(
                    child: Text(
                      'Contact Owner',
                      style:
                      Text_Button_Styles.text_button,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  color: colorsyle.primary,
                  borderRadius:
                  BorderRadius.circular(22),
                ),

                child: GestureDetector(
                  onTap: () async {
                    if (isLandlord) return;

                    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                    final chatId = _buildChatId(currentUserId, widget.post.uid);
                    final userDoc = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.post.uid)
                        .get();

                    final data = userDoc.data()!;
                    await FirebaseFirestore.instance
                        .collection("chats")
                        .doc(chatId)
                        .set({
                      "users": [currentUserId, widget.post.uid],
                      "postId": widget.post.postId,
                      "lastMessage": "",
                      "updatedAt": FieldValue.serverTimestamp(),
                    }, SetOptions(merge: true));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          receiverId: widget.post.uid,
                          receiverName: data["name"],
                          receiverAvatar: data["avatar"],
                          postId: widget.post.postId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorsyle.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.chat, color: Colors.white),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _buildChatId(String a, String b) {
    return (a.hashCode <= b.hashCode)
        ? "$a-$b"
        : "$b-$a";
  }
  Widget _circleButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 50,
        height: 50,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Icon(icon),
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String value,
      String label,
      ) {
    return Column(
      children: [

        Icon(
          icon,
          color: colorsyle.primary,
        ),

        const SizedBox(height: 8),

        Text(
          value,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          label,

          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _utility(
      IconData icon,
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: colorsyle.textPrimary.withOpacity(0.2),
        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icon,
            color: colorsyle.primary,
          ),

          const SizedBox(width: 8),

          Text(text),
        ],
      ),
    );
  }

  Widget _locationCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MapPage(focusPost: widget.post),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: colorsyle.textPrimary.withOpacity(0.2),
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
                      fontSize: 16,
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