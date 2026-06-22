import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/style/styleButton_Text.dart';

import '../../Model/Post.dart';

import 'package:flutter/material.dart';

import 'DetailPage/ApartmentDetail.dart';
import 'DetailPage/HouseDetail.dart';
import 'DetailPage/RoomDetail.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final NumberFormat currency;

  const PostCard({
    super.key,
    required this.post,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, animation, __) {
              return FadeTransition(
                opacity: animation,
                child: _buildDetailPage(),
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, 10),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 140,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                    post.images.isNotEmpty ? post.images.first : '',
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    memCacheWidth: 400,
                    memCacheHeight: 400,
                    fadeInDuration: const Duration(milliseconds: 200),

                    placeholder: (context, url) {
                      return Container(
                        color: Colors.grey.shade200,
                      );
                    },

                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported,
                        ),
                      );
                    },
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 15,
                  left: 18,
                  right: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Text_Button_Styles.text_button
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 18,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              "${post.district}, ${post.city}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 18,
                  right: 18,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      currency.format(post.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDetailPage() {
    switch (post.type.toLowerCase()) {
      case 'house':
        return HouseDetail(post: post);
      case 'room':
        return RoomDetail(post: post);
      case 'apartment':
        return ApartmentDetail(post: post);
      default:
        return CircularProgressIndicator();
    }
  }
}