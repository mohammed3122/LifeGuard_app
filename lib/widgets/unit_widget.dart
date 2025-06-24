import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:raie/models/btn_modle.dart';
import 'package:raie/models/unit_model.dart';
import 'package:raie/services/measure_service.dart';
import 'package:raie/services/test_dialog.dart';
import 'package:raie/widgets/btn.dart';
import 'package:raie/widgets/unit_details_widget.dart';

class UnitWidget extends StatelessWidget {
  final UnitModel details;
  final VoidCallback onMeasure;

  const UnitWidget({
    super.key,
    required this.details,
    required this.onMeasure,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      final months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final period = date.hour >= 12 ? 'م' : 'ص';

      return '${date.day} ${months[date.month - 1]} | ${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $period';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: const Color(0xfffdf8f4),
        shadowColor: const Color(0xff29888d),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2EBEF2), // أزرق
                        Color(0xFF34C88A), // أخضر
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0), // سمك الإطار
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(details.image),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  details.unitName,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'ElMessiri',
                    color: Color(0xff38b6ff),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                text: '',
                children: [
                  buildHealthStatusText(
                    unitName: details.unitName,
                    measure: details.measure,
                  )
                ],
              ),
            ),
            Text.rich(
              textDirection: TextDirection.rtl,
              TextSpan(
                text: 'تاريخ القياس :  ',
                style: TextStyle(
                  color: Color(0xff29888d),
                  fontFamily: 'ElMessiri',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: (details.measure == 'قم بالقياس أولا .' ||
                            details.measure == 'جاري القياس ... ')
                        ? '--- : --- '
                        : formatDate(details.timestamp),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'ElMessiri',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnWidget(
                    btnModel: BtnModel(
                      text: 'تفاصيل',
                      onPressed: () {
                        if (details.measure == 'قم بالقياس أولا .') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.bottomSlide,
                            title: 'تنبيه',
                            desc: '.من فضلك قم بالقياس أولًا قبل عرض التفاصيل',
                            btnOkOnPress: () {},
                            titleTextStyle: const TextStyle(
                              fontFamily: 'ElMessiri',
                              color: Color(0xfffeb800),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            descTextStyle: const TextStyle(
                              fontFamily: 'ElMessiri',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            btnOkColor: Color(
                                0xFF2FBFAD), // درجة بين الأزرق الفاتح والأخضر
                            btnOkText: "تمام",
                            btnOkIcon: Icons.check_circle,
                          ).show();
                        } else if (details.measure == 'جاري القياس ... ') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.infoReverse,
                            animType: AnimType.bottomSlide,
                            title: 'تنبيه',
                            desc: '.برجاء الانتظار حتى يتم جمع القياسات',
                            btnOkOnPress: () {},
                            titleTextStyle: const TextStyle(
                              fontFamily: 'ElMessiri',
                              color: Color(0xff0097ff),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            descTextStyle: const TextStyle(
                              fontFamily: 'ElMessiri',
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            btnOkColor: Color(
                                0xFF2FBFAD), // درجة بين الأزرق الفاتح والأخضر
                            btnOkText: "تمام",
                            btnOkIcon: Icons.check_circle,
                          ).show();
                        } else {
                          showUnitDetailsDialog(context, details);
                        }
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF339cd2), // الأزرق
                          Color(0xFF2fc57f), // الأخضر
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
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
                      onPressed: details.isLoading ? null : onMeasure,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        minimumSize: const Size(80, 35),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: details.isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 15.0,
                            )
                          : const Text(
                              'قياس',
                              style: TextStyle(
                                fontFamily: 'ElMessiri',
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  BtnWidget(
                    btnModel: BtnModel(
                      text: 'اطمن',
                      onPressed: () {
                        showManualMeasurementDialog(
                          context: context,
                          unitName: details.unitName,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
