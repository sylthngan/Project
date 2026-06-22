import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatId;
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;
  final String postId;
  final List<String> users;
  final String lastMessage;
  final DateTime? updatedAt;

  ChatRoomModel({
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
    required this.postId,
    required this.users,
    required this.lastMessage,
    this.updatedAt,
  });

  factory ChatRoomModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoomModel(
      chatId: id,
      receiverId: map["receiverId"] ?? "",
      receiverName: map["receiverName"] ?? "",
      receiverAvatar: map["receiverAvatar"] ?? "",
      postId: map["postId"] ?? "",
      users: List<String>.from(map["users"] ?? []),
      lastMessage: map["lastMessage"] ?? "",
      updatedAt: map["updatedAt"] != null
          ? (map["updatedAt"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "receiverId": receiverId,
      "receiverName": receiverName,
      "receiverAvatar": receiverAvatar,
      "postId": postId,
      "users": users,
      "lastMessage": lastMessage,
      "updatedAt": updatedAt,
    };
  }
}