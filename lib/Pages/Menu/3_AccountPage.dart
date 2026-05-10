import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_room/Login/PassField.dart';
import 'package:rental_room/style/styleButton_Text.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =TextEditingController();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  bool hasPassword = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkPasswordProvider();
  }

  Future<void> checkPasswordProvider() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      hasPassword = user.providerData.any(
            (provider) => provider.providerId == "password",
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> changePassword() async {
    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }
    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters"),
        ),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      if (hasPassword) {
        if (currentPassword.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Enter current password"),
            ),
          );
          return;
        }
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasPassword
                ? "Password changed successfully"
                : "Password created successfully",
          ),
        ),
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      setState(() {
        hasPassword = true;
      });
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";
      if (e.code == "wrong-password") {
        message = "Current password is incorrect";
      }
      else if (e.code == "weak-password") {
        message = "Weak password";
      }
      else if (e.code == "requires-recent-login") {
        message = "Please login again";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              hasPassword
                  ? "Change Password"
                  : "Create Password",

              style: Text_Button_Styles.text6,
            ),

            const SizedBox(height: 30),

            if (hasPassword)
              Column(
                children: [

                  PasswordField(
                    controller: currentPasswordController,
                    label: "Current Password",
                    obscureText: hideCurrentPassword,

                    onToggle: () {
                      setState(() {
                        hideCurrentPassword =
                        !hideCurrentPassword;
                      });
                    },

                    icon: Icons.lock,
                  ),

                  const SizedBox(height: 20),
                ],
              ),

            PasswordField(
              controller: newPasswordController,
              label: "New Password",
              obscureText: hideNewPassword,

              onToggle: () {
                setState(() {
                  hideNewPassword = !hideNewPassword;
                });
              },

              icon: Icons.lock_outline,
            ),

            const SizedBox(height: 20),

            PasswordField(
              controller: confirmPasswordController,
              label: "Confirm Password",
              obscureText: hideConfirmPassword,

              onToggle: () {
                setState(() {
                  hideConfirmPassword =
                  !hideConfirmPassword;
                });
              },

              icon: Icons.lock_reset,
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: changePassword,

                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: Text(
                  hasPassword
                      ? "Change Password"
                      : "Create Password",

                  style: Text_Button_Styles.text3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}