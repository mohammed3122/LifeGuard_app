import 'package:flutter/material.dart';

TextSpan buildHealthStatusText({
  required String unitName,
  required String measure,
}) {
  Color color;
  String status;

  bool isHigh = false;
  bool isLow = false;

  // تحليل القيمة من النص
  final numberReg = RegExp(r'\d+\.?\d*');
  final match = numberReg.firstMatch(measure);
  double? value = match != null ? double.tryParse(match.group(0)!) : null;

  if (value == null) {
    color = Colors.grey;
    status = '';
  } else {
    switch (unitName) {
      case 'درجة الحرارة':
        if (value > 37.5) {
          isHigh = true;
        } else if (value < 36.0) {
          isLow = true;
        }
        break;
      case 'معدل ضربات القلب':
        if (value > 100) {
          isHigh = true;
        } else if (value < 60) {
          isLow = true;
        }
        break;
      case 'نسبة الأكسجين':
        if (value < 94) {
          isLow = true;
        }
        break;
    }

    if (isHigh) {
      color = Colors.red;
      status = ' ( خطر ❗ ) ';
    } else if (isLow) {
      color = const Color.fromARGB(255, 238, 146, 9);
      status = ' ( خلي بالك ⚠️ ) ';
    } else {
      color = Colors.green;
      status = ' ( بخير ✅ ) ';
    }
  }

  return TextSpan(
    text: 'حالتك : ',
    style: const TextStyle(
      color: Color(0xff29888d),
      fontSize: 20,
      fontFamily: 'ElMessiri',
      fontWeight: FontWeight.bold,
    ),
    children: [
      TextSpan(
        text: measure,
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontFamily: 'ElMessiri',
          fontWeight: FontWeight.normal,
        ),
      ),
      TextSpan(
        text: '  $status',
        style: TextStyle(
          color: color,
          fontFamily: 'ElMessiri',
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
