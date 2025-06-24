import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:raie/models/unit_model.dart';
import 'package:raie/widgets/flow_chart.dart';

void showUnitDetailsDialog(BuildContext context, UnitModel unit) {
  String formatDate(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'م' : 'ص';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
  }

  // استخراج الرقم من القياس (مثلاً: "36.5 °C" => 36.5)
  double extractValue(String measure) {
    final regex = RegExp(r'(\d+(\.\d+)?)');
    final match = regex.firstMatch(measure);
    if (match != null) {
      return double.parse(match.group(0)!);
    }
    return 0.0;
  }

  // تحديد النصيحة حسب نوع الوحدة والقيمة
  String advice;
  Color adviceColor;
  final value = extractValue(unit.measure);

  if (value == 0.0) {
    advice =
        'قم بالقياس أولا لتحديد قيمة ${unit.unitName} و لتطمئن علي حالتك الصحية.';
    adviceColor = Colors.grey;
  } else {
    switch (unit.unitName) {
      case 'درجة الحرارة':
        if (value > 37.5) {
          advice =
              ' الحرارة مرتفعة ! خذ خافض حرارة وابقَ في راحة وتابع حالتك🌡️';
          adviceColor = Colors.red;
        } else if (value < 36.0) {
          advice = 'حرارتك منخفضة ، حاول التدفئة وتناول مشروبات دافئة 🥶';
          adviceColor = Colors.orange;
        } else {
          advice = ' حرارتك طبيعية ، استمر في العناية بنفسك ✅ ';
          adviceColor = Colors.green;
        }
        break;

      case 'نسبة الأكسجين':
        if (value < 94) {
          advice =
              ' نسبة الأكسجين منخفضة ! تنفس بعمق وإذا استمر الوضع ، استشر طبيبك.';
          adviceColor = Colors.red;
        } else {
          advice = '✅ نسبة الأكسجين جيدة، استمر على هذا النمط.';
          adviceColor = Colors.green;
        }
        break;

      case 'معدل ضربات القلب':
        if (value > 100) {
          advice =
              ' ضربات القلب مرتفعة ، حاول الاسترخاء وقلل القهوة أو المنبهات ❤️ ';
          adviceColor = Colors.red;
        } else if (value < 60) {
          advice = ' ضربات القلب منخفضة، لو تحس بدوخة راجع الطبيب ⚠️ ';
          adviceColor = Colors.orange;
        } else {
          advice = ' معدل ضربات القلب طبيعي. ✅ ';
          adviceColor = Colors.green;
        }
        break;

      default:
        advice = ' لا توجد نصيحة متاحة لهذا النوع من البيانات ℹ️ ';
        adviceColor = Colors.blueGrey;
    }
  }

  AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          unit.unitName,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: Color(0xff0097ff),
            fontFamily: 'ElMessiri',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'القياس :  ${unit.measure}',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xff29888d),
            fontFamily: 'ElMessiri',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'وقت القياس :  ',
            style: const TextStyle(
              color: Color(0xff29888d),
              fontFamily: 'ElMessiri',
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: value == 0.0 ? '--:--' : formatDate(unit.timestamp),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'ElMessiri',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: UnitChart(
            history: unit.history,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          advice,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'ElMessiri',
            color: adviceColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    btnOkText: "تم",
    btnOkOnPress: () {},
  ).show();
}
