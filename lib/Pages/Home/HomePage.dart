import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Model/Post.dart';
import 'package:rental_room/Pages/Home/DetailPost.dart';
import 'package:rental_room/Pages/Home/SearchPage.dart';
import 'package:rental_room/Pages/Map/LocationPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );

  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'House',
    'Apartment',
    'Room',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        elevation: 2,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MapPage(),
            ),
          );
        },
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text(
          'Map',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          _buildHeader(),

                          const SizedBox(height: 30),

                          _buildTitle(),

                          const SizedBox(height: 25),

                          _buildSearchBar(),

                          const SizedBox(height: 25),

                          _buildCategoryList(),

                          const SizedBox(height: 30),

                          _buildSectionTitle(),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: Text('No Posts Found'),
                          ),
                        );
                      }

                      List<PostModel> posts = snapshot.data!.docs
                          .map((e) => PostModel.fromMap(
                        e.data() as Map<String, dynamic>,
                      ))
                          .toList();

                      if (selectedCategory != 'All') {
                        posts = posts.where((e) {
                          return e.type.toLowerCase() ==
                              selectedCategory.toLowerCase();
                        }).toList();
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return _buildPostCard(posts[index]);
                            },
                            childCount: posts.length,
                          ),
                        ),
                      );
                    },
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 120),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              Text(
                'Hi, User!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 5),

              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey,
                  ),

                  SizedBox(width: 4),

                  Text(
                    'Da Nang City',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.05),
              )
            ],
          ),
          child: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Discover',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 5),

        Text(
          'your new house!',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [

        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  SearchPage(),
                ),
              );
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.04),
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
                    'Search house...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 15),

        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.tune,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {

          final category = categories[index];

          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.04),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [

        Text(
          'Property Nearby',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          'See All',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(PostModel post) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(post: post),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [

                Hero(
                  tag: post.postId,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.images.first,
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      currency.format(post.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        child: Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          post.type,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

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
                          '${post.street}, ${post.district}, ${post.city}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      _featureItem(
                        Icons.bed,
                        '${post.bedroom} Bedroom',
                      ),

                      _featureItem(
                        Icons.bathtub,
                        '${post.bathroom} Bathroom',
                      ),

                      _featureItem(
                        Icons.square_foot,
                        '${post.area} m²',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    return Row(
      children: [

        Icon(
          icon,
          size: 18,
          color: Colors.grey,
        ),

        const SizedBox(width: 6),

        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
