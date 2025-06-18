import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final Color color;
  final bool isObscure;
  final FocusNode? focusNode;
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.contentPadding,
    this.color = Colors.blue,
    this.isObscure = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return "Please enter $hintText";
        }
        return null;
      },
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isObscure,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1.2),
        ),
      ),
    );
  }
}
