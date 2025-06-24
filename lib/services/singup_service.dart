// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:raie/widgets/hint.dart';

// // ignore: non_constant_identifier_names
// void SignUpService(BuildContext context) async {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   Hint hintForSingUp = Hint(desc: " ✅ يمكنك الآن تسجيل الدخول ");

//   try {
//     // ignore: unused_local_variable
//     final credential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//     );
//     FirebaseAuth.instance.currentUser!.sendEmailVerification();
//     // ignore: use_build_context_synchronously
//     Navigator.of(context).pushReplacementNamed("signIn");
//     // ignore: use_build_context_synchronously
//     hintForSingUp.hint(context);
//   } on FirebaseAuthException catch (e) {
//     String message = "حدث خطأ، حاول مرة أخرى";
//     if (e.code == 'weak-password') {
//       message = 'كلمة المرور ضعيفة جدًا';
//     } else if (e.code == 'email-already-in-use') {
//       message = 'هذا البريد مستخدم بالفعل';
//     } else {
//       message = e.message ?? message;
//     }

//     AwesomeDialog(
//       titleTextStyle: TextStyle(
//           color: const Color.fromARGB(255, 196, 182, 60),
//           fontSize: 30,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'ElMessiri'),
//       descTextStyle: TextStyle(
//         fontSize: 25,
//         color: Colors.black,
//       ),
//       // ignore: use_build_context_synchronously
//       context: context,
//       dialogType: DialogType.warning,
//       animType: AnimType.rightSlide,
//       title: 'تنبيه',
//       desc: message,
//       btnOkOnPress: () {},
//     ).show();
//   }
// }
