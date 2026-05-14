import 'package:flutter/material.dart';
import 'package:rental_room/style/color.dart';

class myTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPass;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const myTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isPass,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      readOnly: readOnly,
      onTap: onTap,
      cursorColor: colorsyle.primary,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorsyle.primary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorsyle.primary,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}