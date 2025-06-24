import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raie/widgets/dialog_message.dart';

class ForgetPassBtn extends StatelessWidget {
  final TextEditingController emailController;

  const ForgetPassBtn({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        if (emailController.text.trim().isEmpty) {
          showDialogMessage(
            context: context,
            title: 'تنبيه',
            desc: '! برجاء إدخال بريدك الالكتروني ثم أعد المُحاولة',
            type: DialogType.warning,
          );
          return;
        }

        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text.trim(),
          );
          showDialogMessage(
            // ignore: use_build_context_synchronously
            context: context,
            title: 'تم الإرسال',
            desc:
                'برجاء التوجه إلى بريدك الإلكتروني إن كان صحيحًا لتعيين كلمة مرور جديدة',
            type: DialogType.success,
          );
        } catch (e) {
          showDialogMessage(
            // ignore: use_build_context_synchronously
            context: context,
            title: 'تحذير',
            desc: 'حدث خطأ! تأكد من صحة البريد الإلكتروني وحاول مرة أخرى.',
            type: DialogType.warning,
          );
        }
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '! نسيت كلمة المرور ',
          style: TextStyle(
            color: Color(0xff2a918e),
            fontFamily: 'ElMessiri',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
