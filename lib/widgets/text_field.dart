import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required Color iconColor,
  required TextInputType keyboardType,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    style: TextStyle(
      fontFamily: 'ElMessiri',
      fontSize: 16,
    ),
    cursorColor: Color(0xff2a918e),
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: 'ElMessiri',
        color: Color(0xff2a918e),
        fontWeight: FontWeight.bold,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Color(0xff2fbfac),
          width: 1.5,
        ),
      ),
      prefixIcon: Icon(
        icon,
        color: iconColor,
      ),
    ),
    keyboardType: keyboardType,
    validator: validator,
  );
}
