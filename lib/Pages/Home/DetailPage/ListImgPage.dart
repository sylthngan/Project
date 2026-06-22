import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {

  final List<String> images;
  final int initialIndex;

  const GalleryPage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  late PageController controller;
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    controller = PageController(
      initialPage: currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          PageView.builder(
            controller: controller,

            itemCount: widget.images.length,

            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },

            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: CachedNetworkImage(
                  imageUrl: widget.images[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
            },
          ),

          Positioned(
            top: 50,
            left: 20,

            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,

            child: Center(
              child: Text(
                "${currentIndex + 1}/${widget.images.length}",

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}