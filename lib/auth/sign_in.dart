import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raie/services/signin_with_google_service.dart';
import 'package:raie/services/forget_pass_service.dart';
import 'package:raie/widgets/dialog_message.dart';
import 'package:raie/widgets/other_signin.dart';
import 'package:raie/widgets/pass_field.dart';
import 'package:raie/widgets/picture_logo.dart';
import 'package:raie/widgets/text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//منعا لتسرب البيانات
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
        title: Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontFamily: 'ElMessiri',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              PictureLogo(
                image: 'assets/images/users/sign_in_human.webp',
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Life Guard',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'ElMessiri',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'حارس صحتك المخلص',
                    style: TextStyle(
                      color: Color(0xff2a918e),
                      fontFamily: 'ElMessiri',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              buildTextField(
                controller: emailController,
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                iconColor: Colors.blueGrey,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'البريد الإلكتروني غير صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              PassField(
                passwordController: passwordController,
              ),
              SizedBox(height: 5),
              ForgetPassBtn(emailController: emailController),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    constraints:
                        BoxConstraints(minWidth: 250), // زيادة عرض الزر
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF339cd2), // الأزرق
                          Color(0xFF2fc57f), // الأخضر
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
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
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                  child: Center(
                                child: ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2EBEF2), // أزرق
                                        Color(0xFF34C88A), // أخضر
                                      ],
                                    ).createShader(Rect.fromLTWH(
                                        0, 0, bounds.width, bounds.height));
                                  },
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ));
                            },
                          );
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();

                            if (credential.user!.emailVerified) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                  .pushReplacementNamed("homeScreen");
                            } else {
                              showDialogMessage(
                                // ignore: use_build_context_synchronously
                                context: context,
                                title: 'تنبيه',
                                desc:
                                    'الرجاء التوجه إلي بريدك الالكتروني للتحقق من صلاحية الحساب',
                                type: DialogType.info,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();

                            String errorMessage;
                            switch (e.code) {
                              case 'user-not-found':
                                errorMessage =
                                    'لا يوجد مستخدم مسجل بهذا البريد الإلكتروني.';
                                break;
                              case 'wrong-password':
                                errorMessage = 'كلمة المرور غير صحيحة.';
                                break;
                              case 'invalid-email':
                                errorMessage = 'البريد الإلكتروني غير صالح.';
                                break;
                              default:
                                errorMessage = 'البيانات المُدخلة غير صحيحة.';
                                break;
                            }

                            showDialogMessage(
                              // ignore: use_build_context_synchronously
                              context: context,
                              title: 'تحذير',
                              desc: errorMessage,
                              type: DialogType.error,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'دخـول',
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
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      indent: 20,
                      endIndent: 5,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    ' أو عن طريق ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'ElMessiri',
                      fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 5,
                      endIndent: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              OtherSignIN(
                image: 'assets/images/media/google_logo.png',
                onTap: () {
                  signInWithGoogle(context);
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("signUp");
                },
                child: Center(
                  child: Text.rich(
                    textDirection: TextDirection.rtl,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'مش عندك حساب قبل كده؟',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'ElMessiri',
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' اعمل حساب جديد !',
                          style: TextStyle(
                            color: Color(0xff2a918e),
                            fontFamily: 'ElMessiri',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
