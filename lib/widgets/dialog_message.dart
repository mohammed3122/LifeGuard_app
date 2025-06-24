import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showDialogMessage(
    {required BuildContext context,
    required String title,
    required String desc,
    required DialogType type}) {
  AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.rightSlide,
    titleTextStyle: TextStyle(
      color: type == DialogType.error ? Colors.red : Colors.orange,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      fontFamily: 'ElMessiri',
    ),
    descTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.black,
    ),
    title: title,
    desc: desc,
    btnOkText: 'حسناً',
    btnOkOnPress: () {},
  ).show();
}
