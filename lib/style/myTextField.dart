import 'package:flutter/material.dart';

import 'package:rental_room/style/color.dart';

class myTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPass;
  const myTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isPass,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: colorsyle.textPrimary,
        ),

        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
                color: colorsyle.primary
            )
        ),
        focusColor: colorsyle.textPrimary,
      ),
    );
  }
}
