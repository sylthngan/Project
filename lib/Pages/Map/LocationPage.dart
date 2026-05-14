import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Pages/Home/DetailPost.dart';

import '../../Model/Post.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final Completer<GoogleMapController> controller =
  Completer();

  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  PostModel? selectedPost;

  final CameraPosition initialPosition =
  const CameraPosition(
    target: LatLng(
      16.0544,
      108.2022,
    ),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<PostModel> posts =
          snapshot.data!.docs.map((e) {

            return PostModel.fromMap(
              e.data() as Map<String, dynamic>,
            );
          }).toList();

          return Stack(
            children: [

              GoogleMap(
                initialCameraPosition: initialPosition,

                myLocationEnabled: true,

                zoomControlsEnabled: false,

                myLocationButtonEnabled: false,

                mapToolbarEnabled: false,

                markers: _buildMarkers(posts),

                onMapCreated: (GoogleMapController mapController) {
                  controller.complete(mapController);
                },

                onTap: (value) {
                  setState(() {
                    selectedPost = null;
                  });
                },
              ),

              _buildTopBar(),

              if (selectedPost != null)
                _buildBottomCard(),
            ],
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers(List<PostModel> posts) {

    return posts.map((post) {

      return Marker(
        markerId: MarkerId(post.postId),

        position: LatLng(
          post.lat,
          post.lng,
        ),

        infoWindow: InfoWindow(
          title: post.title,
          snippet: currency.format(post.price),
        ),

        onTap: () async {

          final GoogleMapController mapController =
          await controller.future;

          mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(post.lat, post.lng),
            ),
          );

          setState(() {
            selectedPost = post;
          });
        },
      );
    }).toSet();
  }

  Widget _buildTopBar() {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Row(
          children: [

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },

              child: Container(
                width: 55,
                height: 55,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.05),
                    )
                  ],
                ),

                child: const Icon(Icons.arrow_back),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Container(
                height: 55,

                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.05),
                    )
                  ],
                ),

                child: const Row(
                  children: [

                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),

                    SizedBox(width: 10),

                    Text(
                      'Search location...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCard() {

    final post = selectedPost!;

    return Positioned(
      left: 20,
      right: 20,
      bottom: 30,

      child: GestureDetector(
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                post: post,
              ),
            ),
          );
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),

            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(0.08),
              )
            ],
          ),

          child: Row(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: CachedNetworkImage(
                  imageUrl: post.images.isNotEmpty
                      ? post.images.first
                      : "https://via.placeholder.com/300",

                  width: 120,
                  height: 120,

                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      post.title,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      currency.format(post.price),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [

                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            "${post.street}, ${post.district}",

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        _feature(
                          Icons.bed,
                          "${post.bedroom}",
                        ),

                        _feature(
                          Icons.bathtub,
                          "${post.bathroom}",
                        ),

                        _feature(
                          Icons.square_foot,
                          "${post.area}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feature(
      IconData icon,
      String text,
      ) {
    return Row(
      children: [

        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),

        const SizedBox(width: 5),

        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}