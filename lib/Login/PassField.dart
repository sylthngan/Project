import 'package:flutter/material.dart';
import 'package:rental_room/style/color.dart';

class PasswordField extends StatelessWidget {

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggle;
  final IconData icon;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 45,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 13,
        ),
        decoration: InputDecoration(

          labelText: label,

          labelStyle: TextStyle(
            color: colorsyle.textPrimary,
            fontSize: 13,

          ),

          prefixIcon: Icon(
            icon,
            color: colorsyle.primary,
            size: 20
          ),

          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscureText
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: colorsyle.primary,
                size: 15

            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: colorsyle.primary,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: colorsyle.primary,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: colorsyle.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}