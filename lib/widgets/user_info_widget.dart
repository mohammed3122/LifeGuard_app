import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raie/models/info_user_model.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget(
      {super.key, required this.inf0, required this.onChanged});

  final InfoUserModel inf0;
  final VoidCallback onChanged; // الـ Callback التي سيتم استدعاؤها بعد الحفظ

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  bool isLoading = true;

  Map<String, dynamic>? userData;

  getData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        userData = snapshot.data() as Map<String, dynamic>;
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF2EBEF2),
              Color(0xFF34C88A),
            ],
          ),
        ),
        padding: EdgeInsets.all(1), // سمك الإطار
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffe0f7fa), // لون خلفية البلاطة
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide.none, // بدون حدود داخلية
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.inf0.title,
                      style: const TextStyle(
                          fontFamily: 'ElMessiri',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      userData?[widget.inf0.fieldKey ?? '']?.toString() ??
                          widget.inf0.desc,
                      style: const TextStyle(
                          fontFamily: 'ElMessiri', fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                widget.inf0.icon, // Icon next to the text
              ],
            ),
            trailing: (userData?[widget.inf0.fieldKey ?? '']?.toString() ??
                            widget.inf0.desc) ==
                        'غير محدد' ||
                    (userData?[widget.inf0.fieldKey ?? '']?.toString() ??
                            widget.inf0.desc) ==
                        'غير متوفر'
                ? IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xff2b888e),
                    ),
                    onPressed: () {
                      showTextFieldDialog(
                          context, widget.inf0.title, widget.inf0.fieldKey);
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  void showTextFieldDialog(
      BuildContext context, String title, String? fieldKey) {
    final TextEditingController controller = TextEditingController();

    // تعيين القيمة الحالية في الـ controller
    controller.text = userData?[fieldKey ?? '']?.toString() ?? widget.inf0.desc;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'تحديد ${widget.inf0.title}',
              style: const TextStyle(fontFamily: 'ElMessiri'),
            ),
          ),
          content: TextField(
            textAlign: TextAlign.right,
            cursorColor: Color(0xff2b888e),
            textDirection: TextDirection.rtl,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xff2b888e),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: 'أدخل ${widget.inf0.title} ',
              hintStyle: const TextStyle(
                fontFamily: 'ElMessiri',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'ElMessiri',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final newValue = controller.text;
                final key = fieldKey?.trim();

                if (newValue.isNotEmpty && key != null && key.isNotEmpty) {
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // تحديث البيانات في Firebase
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({key: newValue});

                      // تحديث البيانات في الواجهة مباشرة بعد التحديث
                      if (mounted) {
                        setState(() {
                          userData?[key] = newValue;
                        });
                      }

                      // استدعاء الـ callback لتحديث الصفحة الأم
                      widget.onChanged();
                    }

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // غلق الحوار بعد الحفظ
                  } catch (e) {
                    // التعامل مع الأخطاء هنا
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('حدث خطأ أثناء الحفظ: $e'),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'حفظ',
                style: TextStyle(
                  color: Color(0xff2b888e),
                  fontFamily: 'ElMessiri',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
