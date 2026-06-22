import 'package:flutter/material.dart';
import 'package:rental_room/style/color.dart';

class myTextField extends StatelessWidget {

  final String label;
  final TextEditingController controller;
  final bool isPass;
  final IconData icon;

  const myTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isPass,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 45,

      child: TextFormField(

        controller: controller,
        obscureText: isPass,
        style: TextStyle(
          fontSize: 13,
        ),
        decoration: InputDecoration(

          labelText: label,

          labelStyle: TextStyle(
            fontSize: 13,
            color: colorsyle.textPrimary,
          ),
          prefixIcon: Icon(
            icon,
            color: colorsyle.primary,
              size: 20

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