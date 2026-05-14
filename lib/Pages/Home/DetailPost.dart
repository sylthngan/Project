import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Model/Post.dart';


class DetailPage extends StatefulWidget {
  final PostModel post;

  const DetailPage({
    super.key,
    required this.post,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  int currentImage = 0;

  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  @override
  Widget build(BuildContext context) {

    final post = widget.post;

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      body: Stack(
        children: [

          CustomScrollView(
            physics: const BouncingScrollPhysics(),

            slivers: [

              SliverAppBar(
                expandedHeight: 380,

                pinned: true,

                backgroundColor: Colors.white,

                elevation: 0,

                automaticallyImplyLeading: false,

                flexibleSpace: FlexibleSpaceBar(

                  background: Stack(
                    children: [

                      PageView.builder(
                        itemCount: post.images.length,

                        onPageChanged: (value) {
                          setState(() {
                            currentImage = value;
                          });
                        },

                        itemBuilder: (context, index) {

                          return Hero(
                            tag: post.postId,

                            child: CachedNetworkImage(
                              imageUrl: post.images[index],

                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),

                      Positioned(
                        top: 60,
                        left: 20,

                        child: _topButton(
                          Icons.arrow_back,
                              () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      Positioned(
                        top: 60,
                        right: 20,

                        child: _topButton(
                          Icons.favorite_border,
                              () {},
                        ),
                      ),

                      Positioned(
                        bottom: 25,
                        left: 0,
                        right: 0,

                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: List.generate(
                            post.images.length,
                                (index) {

                              final isActive =
                                  currentImage == index;

                              return AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 300,
                                ),

                                margin:
                                const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),

                                width: isActive ? 24 : 8,
                                height: 8,

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(25),

                  decoration: const BoxDecoration(
                    color: Color(0xfff7f7f7),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(
                                  post.title,

                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 5),

                                    Expanded(
                                      child: Text(
                                        "${post.street}, ${post.district}, ${post.city}",

                                        style:
                                        const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),

                            child: Text(
                              currency.format(post.price),

                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),

                      const Text(
                        "Overview",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                        children: [

                          _overviewItem(
                            Icons.bed,
                            "${post.bedroom}",
                            "Bedroom",
                          ),

                          _overviewItem(
                            Icons.bathtub,
                            "${post.bathroom}",
                            "Bathroom",
                          ),

                          _overviewItem(
                            Icons.square_foot,
                            "${post.area}",
                            "m²",
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Facilities",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 15,
                        runSpacing: 15,

                        children: [

                          if (post.airConditioner)
                            _facility(
                              Icons.ac_unit,
                              "Air Conditioner",
                            ),

                          if (post.washingMachine)
                            _facility(
                              Icons.local_laundry_service,
                              "Washing Machine",
                            ),

                          if (post.refrigerator)
                            _facility(
                              Icons.kitchen,
                              "Refrigerator",
                            ),

                          if (post.fan)
                            _facility(
                              Icons.wind_power,
                              "Fan",
                            ),

                          if (post.bed)
                            _facility(
                              Icons.bed,
                              "Bed",
                            ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Description",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        post.description,

                        style: const TextStyle(
                          height: 1.8,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Location",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        height: 220,

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(30),
                        ),

                        clipBehavior: Clip.antiAlias,

                        child: GoogleMap(
                          initialCameraPosition:
                          CameraPosition(
                            target: LatLng(
                              post.lat,
                              post.lng,
                            ),
                            zoom: 15,
                          ),

                          zoomControlsEnabled: false,

                          markers: {
                            Marker(
                              markerId:
                              MarkerId(post.postId),

                              position: LatLng(
                                post.lat,
                                post.lng,
                              ),
                            ),
                          },
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Owner",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(25),

                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              color:
                              Colors.black.withOpacity(
                                0.04,
                              ),
                            )
                          ],
                        ),

                        child: Row(
                          children: [

                            Container(
                              width: 70,
                              height: 70,

                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,

                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://i.pravatar.cc/300',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    "Nguyen Van A",

                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    "Property Owner",

                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 50,
                              height: 50,

                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                BorderRadius.circular(
                                  18,
                                ),
                              ),

                              child: const Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 25,

            child: Row(
              children: [

                Expanded(
                  child: Container(
                    height: 65,

                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                      BorderRadius.circular(22),
                    ),

                    child: const Center(
                      child: Text(
                        "Contact Owner",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Container(
                  width: 65,
                  height: 65,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color:
                        Colors.black.withOpacity(0.05),
                      )
                    ],
                  ),

                  child: const Icon(Icons.call),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 50,
        height: 50,

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),

        child: Icon(icon),
      ),
    );
  }

  Widget _overviewItem(
      IconData icon,
      String value,
      String label,
      ) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.04),
          )
        ],
      ),

      child: Column(
        children: [

          Icon(icon),

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _facility(
      IconData icon,
      String title,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.04),
          )
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(icon),

          const SizedBox(width: 10),

          Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}