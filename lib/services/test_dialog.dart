import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:raie/services/measure_service.dart';

// دالة مساعدة ترجع نصيحة طبية ولونها بناءً على الوحده والقيمة
Map<String, dynamic> getMedicalAdvice({
  required String unitName,
  required String measure,
}) {
  bool isHigh = false;
  bool isLow = false;

  // استخراج القيمة الرقمية
  final numberReg = RegExp(r'\d+\.?\d*');
  final match = numberReg.firstMatch(measure);
  double? value = match != null ? double.tryParse(match.group(0)!) : null;

  if (value != null) {
    switch (unitName) {
      case 'درجة الحرارة':
        if (value > 37.5) {
          isHigh = true;
          // ignore: curly_braces_in_flow_control_structures
        } else if (value < 36.0) isLow = true;
        break;

      case 'معدل ضربات القلب':
        if (value > 100) {
          isHigh = true;
          // ignore: curly_braces_in_flow_control_structures
        } else if (value < 60) isLow = true;
        break;
      case 'نسبة الأكسجين':
        if (value < 94) isLow = true;
        break;
    }
  }

  if (isHigh) {
    return {
      'advice': 'حالتك مرتفعة ! يُفضّل استشارة الطبيب أو المراقبة الدقيقة ⚠️ ',
      'color': Colors.red
    };
  } else if (isLow) {
    return {
      'advice': ' حالتك منخفضة ! حاول الراحة وشرب السوائل وتابع قياساتك 🔔',
      'color': const Color.fromARGB(255, 219, 154, 55)
    };
  } else {
    return {
      'advice': ' حالتك طبيعية ! استمر في روتينك الصحي ✅',
      'color': Colors.green
    };
  }
}

Future<void> showManualMeasurementDialog({
  required BuildContext context,
  required String unitName,
}) async {
  final controller = TextEditingController();
  // Hint hintForSingUp = Hint(
  //     desc: " من هنا ممكن تطمن علي $unitName\n لو بتقيس بجهاز غير Life Guard");

  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xfffef8f3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // hintForSingUp.hint(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xfffef8f3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 35,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            textDirection: TextDirection.rtl,
                            'صـحتـك تهمنا',
                            style: const TextStyle(
                              fontFamily: 'ElMessiri',
                              color: Color(0xff29888d),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 35,
                          ),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'من هنا ممكن تطمن علي $unitName\n',
                                  style: TextStyle(
                                    color: Color(0xff29888d),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ElMessiri',
                                  ),
                                ),
                                TextSpan(
                                  text: 'لو بتقيس بجهاز غير Life Guard',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ElMessiri',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff40b5f9),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'تسـلـم',
                              style: TextStyle(
                                fontFamily: 'ElMessiri',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.info_outline,
              color: Color(0xfffeb800),
              size: 30,
            ),
          ),
          Text(
            'أدخل $unitName',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'ElMessiri',
              color: Color(0xff29888d),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: TextField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        cursorColor: Color(0xff2fbfac),
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
          hintText: unitName == 'درجة الحرارة'
              ? 'مثال: 37.0'
              : unitName == 'معدل ضربات القلب'
                  ? 'مثال: 72'
                  : unitName == 'نسبة الأكسجين'
                      ? 'مثال: 95'
                      : 'أدخل القيمة',
        ),
        keyboardType: TextInputType.phone,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text(
            'إلغاء',
            style: TextStyle(
              fontFamily: 'ElMessiri',
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF339cd2), // الأزرق
                Color(0xFF2fc57f), // الأخضر // الأخضر
              ],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              minimumSize: const Size(80, 35),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {
              final measure = controller.text.trim();

              if (measure.isEmpty) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.scale,
                  title: 'تنبيه',
                  titleTextStyle: const TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Color(0xfffeb800),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  descTextStyle: const TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Color(0xff29888d),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  desc: 'يرجى إدخال $unitName .',
                  btnOkOnPress: () {},
                ).show();
                return;
              }

              final value = double.tryParse(measure);
              if (value == null) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.scale,
                  title: 'تنبيه',
                  titleTextStyle: const TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Color(0xfffeb800),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  descTextStyle: const TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Color(0xff29888d),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  desc: 'من فضلك أدخل قيمة رقمية فقط لـ $unitName.',
                  btnOkOnPress: () {},
                ).show();
                return;
              }

              bool isValid = false;
              switch (unitName) {
                case 'درجة الحرارة':
                  isValid = value >= 34.0 && value <= 42.0;
                  break;
                case 'معدل ضربات القلب':
                  isValid = value >= 40 && value <= 200;
                  break;
                case 'نسبة الأكسجين':
                  isValid = value >= 70 && value <= 100;
                  break;
                default:
                  isValid = true; // لو في وحدات غير دول
              }

              if (!isValid) {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.scale,
                  title: 'قيمة غير منطقية',
                  titleTextStyle: const TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  descTextStyle: const TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Color(0xff29888d),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  desc:
                      'القيمة المدخلة لـ "$unitName" غير منطقية. تأكد من أنها ضمن النطاق الطبيعي.',
                  btnOkOnPress: () {},
                ).show();
                return;
              }

              // ✅ لو كل شيء تمام، نكمل
              Navigator.pop(ctx);

              final adviceData = getMedicalAdvice(
                unitName: unitName,
                measure: measure,
              );

              showDialog(
                context: context,
                builder: (ctx2) => AlertDialog(
                  backgroundColor: const Color(0xfffef8f3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    'نتيجة $unitName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'ElMessiri',
                      color: Color(0xff29888d),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: buildHealthStatusText(
                          unitName: unitName,
                          measure: measure,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        adviceData['advice'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'ElMessiri',
                          fontSize: 16,
                          color: adviceData['color'],
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff72bcc1),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx2),
                      child: const Text(
                        'تمام',
                        style: TextStyle(
                          fontFamily: 'ElMessiri',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'عرض النتيجة',
              style: TextStyle(
                fontFamily: 'ElMessiri',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
