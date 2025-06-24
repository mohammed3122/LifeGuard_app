import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // الانتقال لصفحة تسجيل الدخول بعد 3 ثوانٍ
    Future.delayed(Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously

      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'homeScreen');
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'signIn');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(flex: 2),
            Image.asset(
              'assets/images/icons/life_guard_image.webp',
              width: 250,
            ),
            Spacer(),
            Image.asset(
              'assets/images/icons/logo_alph.webp',
              width: 130,
            ),
          ],
        ),
      ),
    );
  }
}
