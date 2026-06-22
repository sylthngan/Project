import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Model/Post.dart';
import 'package:rental_room/Pages/Home/PostCard.dart';
import 'package:rental_room/Pages/Home/PostService.dart';
import 'package:rental_room/Pages/Home/SearchPage.dart';
import 'package:rental_room/Pages/Map/LocationPage.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PostService postService = PostService();
  final ScrollController _scrollController = ScrollController();
  final NumberFormat currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  final List<String> categories = ['All', 'House', 'Apartment', 'Room'];
  List<PostModel> allPosts = [];
  List<PostModel> filteredPosts = [];
  String selectedCategory = 'All';

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    loadPosts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      loadMorePosts();
    }
  }

  Future<void> loadPosts() async {
    try {
      final result = await postService.getPosts();
      if (!mounted) return;
      setState(() {
        allPosts = result['posts'];
        filteredPosts = List.from(allPosts);
        lastDocument = result['lastDocument'];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore || !hasMore || lastDocument == null) return;
    setState(() => isLoadingMore = true);
    try {
      final result = await postService.getPosts(lastDocument: lastDocument);
      if (result['posts'].isEmpty) {
        setState(() {
          hasMore = false;
          isLoadingMore = false;
        });
        return;
      }
      allPosts.addAll(result['posts']);
      filterPosts(selectedCategory);
      setState(() {
        lastDocument = result['lastDocument'];
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() => isLoadingMore = false);
    }
  }

  Future<void> refreshPosts() async {
    allPosts.clear();
    filteredPosts.clear();
    lastDocument = null;
    hasMore = true;
    setState(() => isLoading = true);
    await loadPosts();
  }

  void filterPosts(String category) {
    selectedCategory = category;
    if (category == 'All') {
      filteredPosts = List.from(allPosts);
    } else {
      filteredPosts = allPosts.where((post) => post.type.toLowerCase() == category.toLowerCase()).toList();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorsyle.primary,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage())),
        icon: const Icon(Icons.map, color: Colors.white, size: 17),
        label: const Text('Map', style: TextStyle(color: Colors.white, fontSize: 15)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPosts,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Title(),
                      const SizedBox(height: 20),
                      _ShopeeSearchBar(),
                      const SizedBox(height: 20),
                      _CategoryList(),
                      const SizedBox(height: 25),
                      _buildTitle_List(),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (filteredPosts.isEmpty)
                const SliverFillRemaining(child: Center(child: Text('No Posts Found')))
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index == filteredPosts.length) {
                        return isLoadingMore ? const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator())) : const SizedBox(height: 80);
                      }
                      return PostCard(post: filteredPosts[index], currency: currency);
                    }, childCount: filteredPosts.length + 1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discover', style: Text_Button_Styles.title1),
        Text('your new places!', style: Text_Button_Styles.title1.copyWith(color: colorsyle.primary.withOpacity(0.7))),
      ],
    );
  }

  Widget _ShopeeSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SearchPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: colorsyle.primary.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: colorsyle.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search for room, apartment...',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ),
            VerticalDivider(color: Colors.grey.shade300, indent: 12, endIndent: 12),
            Icon(Icons.camera_alt_outlined, color: colorsyle.primary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _CategoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => filterPosts(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? colorsyle.primary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected ? [BoxShadow(color: colorsyle.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : colorsyle.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle_List() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Property Nearby', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorsyle.primary)),
        Text('See All', style: TextStyle(fontSize: 13, color: colorsyle.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
