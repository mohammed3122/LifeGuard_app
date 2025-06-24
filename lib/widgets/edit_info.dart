import 'package:flutter/material.dart';

class EditInfo extends StatelessWidget {
  const EditInfo({
    super.key,
    required this.controller,
    required this.label,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.right,
      cursorColor: const Color(0xff2fbfac),
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(
            color: Color(0xff2fbfac),
            width: 1,
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'ElMessiri',
          color: Color(0xff2b888e),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
