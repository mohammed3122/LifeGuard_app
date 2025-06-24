import 'package:flutter/material.dart';

class Hint {
  final String desc;
  Hint({required this.desc});

  void hint(BuildContext context) {
    const double fabHeight = 60; // ارتفاع الـ FAB
    const double fabBottomPadding = 10; // padding من الأسفل
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: fabHeight + fabBottomPadding + 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xff2a918e),
        content: Text(
          desc,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'ElMessiri',
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
