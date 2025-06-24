import 'package:flutter/material.dart';

class BtnModel {
  String text;
  VoidCallback onPressed;

  BtnModel({
    required this.text,
    required this.onPressed,
  });
}
