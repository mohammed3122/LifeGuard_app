import 'package:flutter/material.dart';

class InfoUserModel {
  final String title;
  final String desc;
  final Icon icon;
  final String? fieldKey;

  InfoUserModel({
    required this.title,
    required this.desc,
    required this.icon,
    this.fieldKey,
  });
}
