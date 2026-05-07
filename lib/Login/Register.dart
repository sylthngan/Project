import 'package:flutter/material.dart';
import 'package:rental_room/Login/Auth.dart';
import 'package:rental_room/Login/AuthGG.dart';
import 'package:rental_room/Login/CheckAuth.dart';
import 'package:rental_room/Login/Login.dart';
import '../style/color.dart';
import '../style/styleButton_Text.dart';
import 'MyTextField.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  AuthService authService = AuthService();
  AuthGg authGg = AuthGg();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(15.0),
              child: Column  (
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Welcome to',
                          style: Text_Button_Styles.title1
                      ),
                      SizedBox(width: 6),
                      Text(
                          'HealthCare',
                          style: Text_Button_Styles.title2
                      ),
                    ],
                  ),
                  SizedBox(height: 35),

                  //field input
                  myTextField(
                      label: "Full Name",
                      controller: nameController,
                      isPass: false,
                      icon: Icons.person,

                  ),
                  SizedBox(height: 25),
                  //field birthday
                  TextFormField(
                    controller: birthController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      prefixIcon: Icon(Icons.cake),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17)
                      ),
                    ),

                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                            "${pickedDate.month.toString().padLeft(2, '0')}/"
                            "${pickedDate.year}";

                        setState(() {
                          birthController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 25),
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
                  SizedBox(height: 25),
                  myTextField(
                    label: "Confirm Password",
                    controller: confirmController,
                    isPass: true,
                    icon: Icons.lock,

                  ),
                  SizedBox(height: 25),
                  myTextField(
                    label: "Phone",
                    controller: phoneController,
                    isPass: false,
                    icon: Icons.phone,
                  ),
                  SizedBox(height: 40),
                  //button register
                  registerButton(context),
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

                  //sign up with gg
                  registerWithGG(),
                  SizedBox(height: 25),
                  //have an account (to login page)
                  toLoginPage(context)
                ],
              ),
            ),
          ),
      )
    );
  }
  //have an account (to login page)
  GestureDetector toLoginPage(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Login()));
        },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'Already have an account?',
              style: Text_Button_Styles.subtitle
          ),
          SizedBox(width: 5),
          Text(
            'Sign in',
            style: Text_Button_Styles.subtitle1,
          ),
        ],
      ),
    );
  }
//register w gg
  GestureDetector registerWithGG() {
    return GestureDetector(
      onTap: () async{
        try {
          final user = await authGg.signInWithGoogle();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Checkauth()),
                (route) => false,
          );

        } catch (e) {
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
                'Sign up with Google',
                style: Text_Button_Styles.text_button2,
              )
            ]
        ),
      ),
    );
  }

  // button register
  SizedBox registerButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () async{
          if (nameController.text.isEmpty ||
              emailController.text.isEmpty ||
              passController.text.isEmpty ||
              confirmController.text.isEmpty) {
            displayMessage("Please enter full info");
            return;
          }

          if (passController.text != confirmController.text) {
            displayMessage("Password dont match");
            return;
          }
          try {
            await authService.register(
              email: emailController.text,
              password: passController.text,
              fullName: nameController.text,
              birthday: birthController.text,
              phone: phoneController.text,

            );

            displayMessage("Register success");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Checkauth()),
                  (route) => false,
            );
          } catch (e) {
            displayMessage(e.toString());
          }
        },
        child: Text(
          'Sign up',
          style: Text_Button_Styles.text_button,
        ),
        style: Text_Button_Styles.button1,
      ),
    );
  }

  void displayMessage(String message){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(message),
    ));
  }
}
