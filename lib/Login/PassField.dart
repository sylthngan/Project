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

    return TextFormField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(

        labelText: label,

        labelStyle: TextStyle(
          color: colorsyle.textPrimary,
        ),

        prefixIcon: Icon(
          icon,
          color: colorsyle.primary,
        ),

        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscureText
                ? Icons.visibility_off
                : Icons.visibility,
            color: colorsyle.primary,
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
    );
  }
}