import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/Pages/Chat/UserService.dart';
import 'package:rental_room/style/color.dart';
import 'ChatPage.dart';

class ChatInboxPage extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  ChatInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("users", arrayContains: currentUserId)
            .orderBy("updatedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No messages yet", style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final users = List<String>.from(data["users"] ?? []);
              final String otherId =
              users.firstWhere((id) => id != currentUserId, orElse: () => "");

              final Map<String, dynamic> userInfos =
              Map<String, dynamic>.from(data["userInfos"] ?? {});

              final Map<String, dynamic> otherInfo =
              Map<String, dynamic>.from(userInfos[otherId] ?? {});

              final String fullName =
                  otherInfo["fullName"]?.toString() ?? "User";

              final String avatar =
                  otherInfo["avatar"]?.toString() ?? "";

              final String lastMsg = data["lastMessage"] ?? "";
              final String lastSenderId = data["lastSenderId"] ?? "";

              final String prefix =
              lastSenderId == currentUserId ? "You: " : "";

              final Timestamp? updatedAt = data["updatedAt"] as Timestamp?;

              return _chatCard(
                context,
                fullName,
                avatar,
                prefix + lastMsg,
                updatedAt,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        receiverId: otherId,
                        receiverName: fullName,
                        receiverAvatar: avatar,
                        postId: data["postId"] ?? "",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('E').format(date);
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
  Widget _chatCard(
      BuildContext context,
      String name,
      String avatar,
      String lastMessage,
      Timestamp? time,
      VoidCallback onTap,
      ) {
    final date = time?.toDate();
    final timeText = date != null ? _formatDate(date) : "";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorsyle.textPrimary.withOpacity(0.1)xs,
              backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              child: avatar.isEmpty
                  ? Icon(
                  Icons.person,
                  color: colorsyle.primary,
              )
                  : null,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:  TextStyle(
                      color: colorsyle.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage.isEmpty ? "Start a conversation" : lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorsyle.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeText,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorsyle.textPrimary,
                        ),
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
}
