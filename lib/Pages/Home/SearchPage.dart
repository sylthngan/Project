import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Model/Post.dart';
import 'package:rental_room/Pages/Home/PostCard.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final NumberFormat currency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  
  List<String> recentSearches = ['Phòng trọ giá rẻ', 'Chung cư Đà Nẵng', 'Nhà nguyên căn', 'Phòng Studio'];
  List<String> hotKeywords = ['Gần đại học', 'Có ban công', 'Full nội thất', 'Giảm giá 50%', 'Chính chủ'];
  
  List<PostModel> searchResults = [];
  bool isSearching = false;
  bool showResults = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isSearching = true;
      showResults = true;
    });

    if (!recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
        if (recentSearches.length > 8) recentSearches.removeLast();
      });
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        searchResults = snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList();
        isSearching = false;
      });
    } catch (e) {
      debugPrint("Lỗi tìm kiếm: $e");
      setState(() => isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorsyle.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: const Color(0xffF3F4F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            onSubmitted: _onSearch,
            onChanged: (val) {
              if (val.isEmpty) setState(() => showResults = false);
            },
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "Tìm kiếm bài đăng...",
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty 
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => showResults = false);
                    },
                    child: const Icon(Icons.cancel, size: 18, color: Colors.grey),
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _onSearch(_searchController.text),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 15),
              child: Text(
                "Tìm",
                style: TextStyle(color: colorsyle.primary, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: showResults ? _buildSearchResults() : _buildSearchSuggestions(),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tìm kiếm gần đây", style: Text_Button_Styles.text6),
              GestureDetector(
                onTap: () => setState(() => recentSearches = []),
                child: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: recentSearches.map((e) => _buildChip(e)).toList(),
          ),
          const SizedBox(height: 30),
        ],
        Text("Khám phá từ khóa hot", style: Text_Button_Styles.text6),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: hotKeywords.map((e) => _buildChip(e, isHot: true)).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {bool isHot = false}) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _onSearch(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isHot ? colorsyle.primary.withOpacity(0.05) : const Color(0xffF3F4F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHot ? colorsyle.primary.withOpacity(0.2) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isHot ? colorsyle.primary : Colors.black87,
            fontSize: 13,
            fontWeight: isHot ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Không tìm thấy kết quả nào cho \"${_searchController.text}\"",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return PostCard(post: searchResults[index], currency: currency);
      },
    );
  }
}
