import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContractViewer extends StatefulWidget {
  final String contractId;

  const ContractViewer({super.key, required this.contractId});

  @override
  State<ContractViewer> createState() => _ContractViewerState();
}

class _ContractViewerState extends State<ContractViewer> {
  final TextEditingController signatureController = TextEditingController();

  Future<void> signContract(String role) async {
    await FirebaseFirestore.instance
        .collection("contracts")
        .doc(widget.contractId)
        .update({
      role: signatureController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("contracts")
            .doc(widget.contractId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "RENTAL CONTRACT",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(data["content"] ?? ""),

                  const SizedBox(height: 20),

                  TextField(
                    controller: signatureController,
                    decoration: const InputDecoration(
                      labelText: "Your signature",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () => signContract("signatureTenant"),
                    child: const Text("Sign"),
                  ),

                  const SizedBox(height: 10),

                  Text("Host: ${data["signatureHost"] ?? ""}"),
                  Text("Tenant: ${data["signatureTenant"] ?? ""}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}