import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raie/widgets/hint.dart';
import 'package:raie/widgets/pass_field.dart';
import 'package:raie/widgets/picture_logo.dart';
import 'package:raie/widgets/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUP createState() => SignUP();
}

class SignUP extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDateOfBirth;

  Hint hintForSingUp = Hint(desc: " ✅ يمكنك الآن تسجيل الدخول ");

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'gender': selectedGender,
          'age': selectedDateOfBirth != null
              ? DateTime.now().year - selectedDateOfBirth!.year
              : null,
          'phone': phoneController.text.trim(),
        });

        print("User Added ✅");
      } else {
        print("No user logged in ❌");
      }
    } catch (e) {
      print("Failed to add user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF339cd2), // الأزرق
                Color(0xFF2fc57f), // الأخضر
              ],
            ),
            borderRadius: BorderRadiusDirectional.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        title: Text(
          'إنشاء حساب',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'ElMessiri',
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 5000),
        curve: Curves.easeIn,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                const PictureLogo(
                    image: 'assets/images/users/sign_up_human.webp'),
                Center(
                  child: Text(
                    '⭐ رعايـة صـحتـك علينا .. فاشترك معانا⭐',
                    style: TextStyle(
                      color: Color(0xff2b888e),
                      fontFamily: 'ElMessiri',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // ✅ الحقول
                Column(
                  children: [
                    buildTextField(
                      keyboardType: TextInputType.text,
                      controller: firstNameController,
                      label: 'الاسم الأول',
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال الاسم الأول' : null,
                      iconColor: Color(0xff2b888e),
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      keyboardType: TextInputType.text,
                      controller: lastNameController,
                      label: 'الاسم الأخير',
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال الاسم الأخير' : null,
                      iconColor: Color(0xff2b888e),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: Color(0xff2b888e),
                                colorScheme: ColorScheme.light(
                                    primary: Color(0xff2b888e)),
                                buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDateOfBirth = pickedDate;
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'ElMessiri',
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: 'ElMessiri',
                              fontSize: 18,
                            ),
                            labelText: selectedDateOfBirth == null
                                ? 'تاريخ الميلاد'
                                : '${selectedDateOfBirth!.year}-${selectedDateOfBirth!.month}-${selectedDateOfBirth!.day}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.deepPurple,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xff2a918e),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (value) => selectedDateOfBirth == null
                              ? 'يرجى تحديد تاريخ الميلاد'
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      style: TextStyle(
                        fontFamily: 'ElMessiri',
                        fontSize: 17,
                      ),
                      dropdownColor: Color.fromARGB(255, 185, 219, 221),
                      value: selectedGender,
                      borderRadius: BorderRadius.circular(20),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Color(0xff2b888e)),
                      items: ['ذكر', 'أنثى']
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontFamily: 'ElMessiri',
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'الجنس',
                        labelStyle: TextStyle(
                          fontFamily: 'ElMessiri',
                          color: Color(0xff2a918e),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff2a918e),
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.wc, color: Colors.pinkAccent),
                      ),
                      validator: (value) =>
                          value == null ? 'يرجى تحديد الجنس' : null,
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      controller: emailController,
                      label: 'البريد الإلكتروني',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'البريد الإلكتروني غير صحيح';
                        }
                        return null;
                      },
                      iconColor: Colors.blueGrey,
                    ),
                    const SizedBox(height: 12),
                    PassField(
                      passwordController: passwordController,
                    ),
                    const SizedBox(height: 12),
                    buildTextField(
                      controller: phoneController,
                      label: 'رقم الهاتف',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                      iconColor: Colors.blue,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF2EBEF2), // الأزرق
                                Color(0xFF34C88A), // الأخضر
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40),
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();

                                  if (credential.user != null) {
                                    await addUser();
                                    // ignore: use_build_context_synchronously
                                    hintForSingUp.hint(context);
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            'signIn', (route) => false);
                                  }
                                } on FirebaseAuthException catch (e) {
                                  String message = "حدث خطأ، حاول مرة أخرى";
                                  if (e.code == 'weak-password') {
                                    message = 'كلمة المرور ضعيفة جدًا';
                                  } else if (e.code == 'email-already-in-use') {
                                    message = 'هذا البريد مستخدم بالفعل';
                                  } else {
                                    message = e.message ?? message;
                                  }

                                  AwesomeDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.rightSlide,
                                    descTextStyle: TextStyle(
                                      fontFamily: 'ElMessiri',
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    titleTextStyle: TextStyle(
                                      fontFamily: 'ElMessiri',
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                    title: 'تنبيه',
                                    desc: message,
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text(
                              'إنشاء الحساب',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ElMessiri',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
