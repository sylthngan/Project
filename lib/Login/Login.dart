
import 'package:flutter/material.dart';
import 'package:rental_room/Login/Auth.dart';
import 'package:rental_room/Login/AuthGG.dart';
import 'package:rental_room/Login/CheckAuth.dart';

import 'package:rental_room/Login/MyTextField.dart';
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
                    SizedBox(height: 35),
          
                    //field input
                    myTextField(
                        label: "Email",
                        controller: emailController,
                        isPass: false,
                        icon: Icons.mail,

                    ),
                    SizedBox(height: 25),
                    myTextField(
                      label: "Password",
                      controller: passController,
                      isPass: true,
                      icon: Icons.lock,

                    ),
                    SizedBox(height: 40),

                    //button Login
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: loginButton(),
                    ),
                    SizedBox(height: 40),
                    //
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0,0,30,0),
                      child: Row(
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
                    SizedBox(height: 28),
                    //sign with gg
                    loginWithGG(),
                    SizedBox(height: 25),
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
          SizedBox(width: 5),
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

            if (user != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Checkauth()),
                    (route) => false,
              );
            } else {
              displayMessage("User cancelled login");
            }

          } catch (e) {
            print(e);
            displayMessage("Google sign-in failed");
          }
        },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(3, 3),
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
              SizedBox(width: 5),
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
      onPressed: () async{
        try {
          await authService.login(
            emailController.text,
            passController.text,
          );

          displayMessage("Login success");
        } catch (e) {
          displayMessage("Login failed");
        }
        },
      child: Text(
        'Sign in',
        style: Text_Button_Styles.text_button,
      ),
      style: Text_Button_Styles.button1,
    );
  }

  void displayMessage(String message){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(message),
    ));
  }
}
