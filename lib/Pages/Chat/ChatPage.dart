import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rental_room/style/color.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'Contract.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverAvatar;
  final String postId;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAvatar,
    required this.postId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  String? myName;
  String? myAvatar;
  final ImagePicker _picker = ImagePicker();

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  String get chatId {
    final ids = [currentUserId ?? "unknown", widget.receiverId];
    ids.sort();
    return ids.join("_");
  }

  @override
  void initState() {
    super.initState();
    _fetchMyInfo().then((info) {
      if (mounted) {
        setState(() {
          myName = info["fullName"];
          myAvatar = info["avatar"];
        });
        updateChatUsers();
      }
    });
  }

  Future<Map<String, dynamic>> _fetchMyInfo() async {
    if (currentUserId == null) return {"fullName": "User", "avatar": ""};
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .get();

    return {
      "fullName": doc.data()?["fullName"] ?? "User",
      "avatar": doc.data()?["avatar"] ?? "",
    };
  }

  Future<void> updateChatUsers() async {
    final receiverDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.receiverId)
        .get();

    final receiverData = receiverDoc.data() ?? {};

    await FirebaseFirestore.instance.collection("chats").doc(chatId).set({
      "userInfos": {
        currentUserId: {
          "fullName": myName,
          "avatar": myAvatar,
        },
        widget.receiverId: {
          "fullName": receiverData["fullName"] ?? widget.receiverName,
          "avatar": receiverData["avatar"] ?? widget.receiverAvatar,
        },
      }
    }, SetOptions(merge: true));
  }

  Future<void> sendMessage() async {
    if (controller.text.trim().isEmpty) return;

    final meInfo = {
      "fullName": myName ?? "User",
      "avatar": myAvatar ?? "",
    };

    final message = controller.text.trim();
    final chatRef = FirebaseFirestore.instance.collection("chats").doc(chatId);

    await chatRef.collection("messages").add({
      "senderId": currentUserId,
      "message": message,
      "type": "text",
      "timestamp": FieldValue.serverTimestamp(),
    });

    await chatRef.set({
      "users": [currentUserId, widget.receiverId],
      "postId": widget.postId,
      "lastMessage": message,
      "lastSenderId": currentUserId,
      "updatedAt": FieldValue.serverTimestamp(),
      "userInfos": {
        currentUserId: meInfo,
        widget.receiverId: {
          "fullName": widget.receiverName,
          "avatar": widget.receiverAvatar,
        }
      }
    }, SetOptions(merge: true));

    controller.clear();
  }

  Future<void> _sendImages(List<File> images) async {
    if (images.isEmpty) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      const String cloudName = "djrmffdbo";
      const String uploadPreset = "rentalroom";

      for (File image in images) {
        var request = http.MultipartRequest(
          "POST",
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
        );

        request.fields['upload_preset'] = uploadPreset;
        request.files.add(await http.MultipartFile.fromPath("file", image.path));

        var response = await request.send();
        var resBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          var data = jsonDecode(resBody);
          String downloadUrl = data["secure_url"];

          final chatRef = FirebaseFirestore.instance.collection("chats").doc(chatId);
          await chatRef.collection("messages").add({
            "senderId": currentUserId,
            "type": "image",
            "message": downloadUrl,
            "timestamp": FieldValue.serverTimestamp(),
          });

          await chatRef.set({
            "users": [currentUserId, widget.receiverId],
            "postId": widget.postId,
            "lastMessage": "📷 Photo",
            "lastSenderId": currentUserId,
            "updatedAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<void> sendContract(String content) async {
    final contractRef =
        FirebaseFirestore.instance.collection("contracts").doc();

    await contractRef.set({
      "hostName": myName,
      "tenantName": widget.receiverName,
      "postId": widget.postId,
      "content": content,
      "signatureHost": "",
      "signatureTenant": "",
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    });

    final chatRef = FirebaseFirestore.instance.collection("chats").doc(chatId);

    await chatRef.collection("messages").add({
      "senderId": currentUserId,
      "type": "contract",
      "contractId": contractRef.id,
      "message": "📄 Contract",
      "timestamp": FieldValue.serverTimestamp(),
    });

    await chatRef.set({
      "lastMessage": "📄 Contract",
      "lastSenderId": currentUserId,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void _openContractForm() {
    final TextEditingController contractController = TextEditingController(
      text: """
HỢP ĐỒNG THUÊ NHÀ

Bên cho thuê: ${myName ?? ""}
Bên thuê: ${widget.receiverName}

Phòng: ${widget.postId}

Điều khoản:
- Giá thuê: ...
- Thời hạn: ...
- Quy định: ...
""",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Create Contract", style: TextStyle(color: colorsyle.primary, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: contractController,
            maxLines: 12,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              hintText: "Enter contract details...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await sendContract(contractController.text);
              },
              style: ElevatedButton.styleFrom(backgroundColor: colorsyle.primary),
              child: const Text("Send", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openContractDetail(String contractId) {
    showDialog(
      context: context,
      builder: (context) => ContractViewer(contractId: contractId),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: colorsyle.primary),
              title: const Text('Photo Library'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile> images = await _picker.pickMultiImage(imageQuality: 70);
                if (images.isNotEmpty) {
                  _sendImages(images.map((e) => File(e.path)).toList());
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: colorsyle.primary),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                if (image != null) {
                  _sendImages([File(image.path)]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewFullImage(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0),
          body: Center(child: InteractiveViewer(child: Image.network(url))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorsyle.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.receiverAvatar.isNotEmpty ? NetworkImage(widget.receiverAvatar) : null,
              child: widget.receiverAvatar.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receiverName, style: TextStyle(color: colorsyle.primary, fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text("Active now", style: TextStyle(color: Colors.green, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final isMe = data["senderId"] == currentUserId;
                    final type = data["type"] ?? "text";
                    final timestamp = data["timestamp"] as Timestamp?;
                    return _buildMessageItem(data, isMe, type, timestamp);
                  },
                );
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> data, bool isMe, String type, Timestamp? timestamp) {
    final senderName = isMe ? (myName ?? "You") : widget.receiverName;
    final senderAvatar = isMe ? (myAvatar ?? "") : widget.receiverAvatar;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 40, right: 40),
            child: Text(
              senderName,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: senderAvatar.isNotEmpty ? NetworkImage(senderAvatar) : null,
                    child: senderAvatar.isEmpty ? const Icon(Icons.person, size: 14) : null,
                  ),
                ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: Container(
                  padding: type == "image" ? EdgeInsets.zero : const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? (type == "contract" ? Colors.transparent : colorsyle.primary) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(!isMe ? 0 : 20),
                      bottomRight: Radius.circular(isMe ? 0 : 20),
                    ),
                    boxShadow: type == "image" || type == "contract" ? [] : [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: _buildMessageContent(data, type, isMe),
                ),
              ),
              const SizedBox(width: 8),
              if (isMe)
                CircleAvatar(
                  radius: 14,
                  backgroundImage: senderAvatar.isNotEmpty ? NetworkImage(senderAvatar) : null,
                  child: senderAvatar.isEmpty ? const Icon(Icons.person, size: 14) : null,
                ),
            ],
          ),
          if (timestamp != null)
            Padding(
              padding: EdgeInsets.only(top: 4, left: isMe ? 0 : 42, right: isMe ? 42 : 0),
              child: Text(
                DateFormat('HH:mm').format(timestamp.toDate()),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> data, String type, bool isMe) {
    final contractId = data["contractId"] as String?;
    if (type == "contract") {
      return InkWell(
        onTap: () {
          if (contractId == null || contractId.isEmpty) return;
          _openContractDetail(contractId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorsyle.primary.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorsyle.textPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description,
                  size: 18,
                  color: colorsyle.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rental Contract",
                      style: TextStyle(
                        color: colorsyle.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tap to view & sign document",
                      style: TextStyle(
                        fontSize: 11,
                        color: colorsyle.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorsyle.primary,
              ),
            ],
          ),
        ),
      );
    } else if (type == "image") {
      return GestureDetector(
        onTap: () => _viewFullImage(data["message"]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            data["message"],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 200, height: 150, color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      );
    } else {
      return Text(
        data["message"] ?? "",
        style: TextStyle(
          color: isMe ? Colors.white : colorsyle.text3,
          fontSize: 15,
        ),
      );
    }
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))]),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.description_outlined, color: colorsyle.primary, size: 28),
            onPressed: _openContractForm,
          ),
          IconButton(
            icon: Icon(Icons.image_outlined, color: colorsyle.primary, size: 28),
            onPressed: _showImageSourceDialog,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xffF3F4F8), borderRadius: BorderRadius.circular(25)),
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Aa", border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: sendMessage,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: colorsyle.primary,
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
