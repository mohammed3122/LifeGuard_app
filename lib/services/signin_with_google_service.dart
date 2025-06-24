import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return; // المستخدم لغى تسجيل الدخول

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    User? user = userCredential.user;

    if (user != null) {
      // نتحقق هل المستخدم موجود بالفعل في Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // لو أول مرة يسجل، نضيف بياناته
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': user.displayName?.split(" ").first ?? '',
          'lastName': user.displayName?.split(" ").last ?? '',
          'email': user.email ?? '',
          'gender': null,
          'age': null,
          'phone': null,
        });
        print("✅ User added to Firestore from Google sign-in");
      } else {
        print("ℹ️ User already exists in Firestore");
      }

      // نروح للصفحة الرئيسية
      Navigator.of(context)
          .pushNamedAndRemoveUntil("homeScreen", (route) => false);
    }
  } catch (e) {
    print("❌ Google Sign-In error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("حدث خطأ أثناء تسجيل الدخول بجوجل"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
