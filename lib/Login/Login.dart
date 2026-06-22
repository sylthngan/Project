
import 'package:flutter/material.dart';
import 'package:rental_room/Login/Auth.dart';
import 'package:rental_room/Login/AuthGG.dart';
import 'package:rental_room/Login/CheckAuth.dart';

import 'package:rental_room/Login/MyTextField.dart';
import 'package:rental_room/Login/PassField.dart';
import 'package:rental_room/Login/Register.dart';
import 'package:rental_room/style/color.dart';
import 'package:rental_room/style/styleButton_Text.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final AuthService authService = AuthService();
  final AuthGg authGg = AuthGg();
  bool hidePassword = true;
  bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                    'lib/img/Auth1.jpg',
                  width: 500,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Column  (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to',
                          style: Text_Button_Styles.title1
                        ),
                        SizedBox(width: 6),
                        Text(
                            'RentalService',
                            style: Text_Button_Styles.title2
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    //field input
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          myTextField(
                              label: "Email",
                              controller: emailController,
                              isPass: false,
                              icon: Icons.mail,

                          ),
                          const SizedBox(height: 15),
                          PasswordField(
                            controller: passController,
                            label: "Password",
                            obscureText: hidePassword,

                            onToggle: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },

                            icon: Icons.lock,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    //button Login
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: loginButton(),
                    ),
                    const SizedBox(height: 30),
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                                thickness: 0.5, color: colorsyle.textPrimary
                            ),
                          ),
                          Text(
                              'Or continue with',
                            style: Text_Button_Styles.subtitle,
                          ),
                          Expanded(
                            child: Divider(
                                thickness: 0.5, color: colorsyle.textPrimary
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    //sign with gg
                    loginWithGG(),
                    const SizedBox(height: 25),
                    //Navigator to register
                    toRegister(context)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//Navigator to register
  GestureDetector toRegister(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Register()));
        },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
              'Don\'t have an account?',
              style: Text_Button_Styles.subtitle
          ),
          const SizedBox(width: 5),
          Text(
            'Sign up',
            style: Text_Button_Styles.subtitle1,
          ),
        ],
      ),
    );
  }
// button login with google
  GestureDetector loginWithGG() {
    return GestureDetector(
        onTap: () async {
          try {
            final user = await authGg.signInWithGoogle();
            if (!mounted) return;
            if (user == null) {
              displayMessage("User cancelled login");
            }
          } catch (e) {
            debugPrint(e.toString());
            displayMessage("Google sign-in failed");
          }
        },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(1, 2),
              )
            ]
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Image.asset(
                'lib/img/gg.png',
                width: 40,
                height: 50,
              ),
              const SizedBox(width: 5),
              Text(
                'Sign in with Google',
                style: Text_Button_Styles.text_button2,
              )
            ]
        ),
      ),
    );
  }

  // login button
  ElevatedButton loginButton() {
    return ElevatedButton(
      style: Text_Button_Styles.button1,
      onPressed: isLoading ? null : () async {
        if(emailController.text.trim().isEmpty){
          displayMessage("Enter email");
          return;
        }

        if(passController.text.trim().isEmpty){
          displayMessage("Enter password");
          return;
        }
        if(isLoading) return;
        setState(() {
          isLoading = true;
        });
        try {
          await authService.login(
            emailController.text.trim(),
            passController.text.trim(),
          );
          if (!mounted) return;

        } catch (e) {
          displayMessage(e.toString());
        }finally {

          if(mounted){
            setState(() {
              isLoading = false;
            });
          }
        }
      },
      child: isLoading ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      ) : Text(
        'Sign in',
        style: Text_Button_Styles.text_button,
      ),
    );
  }

  void displayMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
