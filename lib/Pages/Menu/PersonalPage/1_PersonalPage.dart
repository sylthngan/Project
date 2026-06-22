import 'package:flutter/material.dart';
import 'package:rental_room/Model/Post.dart';
import 'package:rental_room/Model/User.dart';
import 'package:rental_room/Pages/Menu/2_ProfilePage.dart';
import 'package:rental_room/Pages/Menu/PersonalPage/Create_post.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class PersonalPage extends StatefulWidget {
  final UserModel user;
  final List<PostModel> posts;

  const PersonalPage({
    super.key,
    required this.user,
    required this.posts,
  });

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  int getTotalFavorites() {
    int total = 0;
    for (var post in widget.posts) {
      total += post.favorites;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: colorsyle.primary,
          title: Text(
            widget.user.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    /// AVATAR
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: colorsyle.primary.withOpacity(0.1),
                      backgroundImage: widget.user.avatar.isNotEmpty
                          ? NetworkImage(widget.user.avatar)
                          : null,
                      child: widget.user.avatar.isEmpty
                          ? Icon(
                              Icons.person,
                              color: colorsyle.primary,
                              size: 45,
                            )
                          : null,
                    ),

                    /// STATS
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStat(
                            widget.posts.length.toString(),
                            "Posts",
                          ),
                          buildStat(
                            getTotalFavorites().toString(),
                            "Likes",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfilePage()),
                          );
                        },
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: colorsyle.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorsyle.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreatePostPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              const Divider(height: 1),

              /// POSTS GRID
              if (widget.posts.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "No posts yet",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.posts.length,
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    PostModel post = widget.posts[index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            post.images.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  post.favorites.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStat(String value, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
