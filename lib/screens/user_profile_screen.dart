import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:raie/models/info_user_model.dart';
import 'package:raie/widgets/edit_info.dart';
import 'package:raie/widgets/user_info_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isLoading = true;
  Map<String, dynamic>? userData;
  int rebuildFlag = 0; // متغير جديد

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
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    List<InfoUserModel> info = [
      InfoUserModel(
        title: 'اسم المستخدم',
        desc: '${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? ''}',
        icon: Icon(
          Icons.person,
          color: Color(0xff2b888e),
          size: 30,
        ),
      ),
      InfoUserModel(
        title: 'البريد الإلكتروني',
        desc: userData?['email'] ?? 'غير متوفر',
        icon: Icon(
          Icons.email,
          color: Color(0xff315086),
          size: 25,
        ),
      ),
      InfoUserModel(
          title: 'العمر',
          desc: userData?['age']?.toString() ?? 'غير محدد',
          fieldKey: 'age',
          icon: Icon(
            Icons.calendar_month_sharp,
            color: Colors.purple,
            size: 25,
          )),
      InfoUserModel(
          title: 'رقم الهاتف',
          desc: userData?['phone']?.toString() ?? 'غير متوفر',
          fieldKey: 'phone',
          icon: Icon(
            Icons.phone,
            color: Colors.blue,
            size: 25,
          )),
      InfoUserModel(
        title: 'الجنس',
        desc: userData?['gender'] ?? 'غير محدد',
        fieldKey: 'gender',
        icon: Icon(
          Icons.wc_sharp,
          color: Colors.pink,
          size: 25,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xfff5efe6),
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
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            fontFamily: 'ElMessiri',
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: isLoading
            ? Center(
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2EBEF2), // أزرق
                        Color(0xFF34C88A), // أخضر
                      ],
                    ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                  },
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
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
                          radius: 68,
                          backgroundImage:
                              AssetImage('assets/images/users/user.webp'),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        textDirection: TextDirection.rtl,
                        userData != null
                            ? 'أهلا بيك يا ${userData?['firstName'] ?? ''} 👋'
                            : 'لم يتم العثور على بيانات',
                        style: TextStyle(
                          fontFamily: 'ElMessiri',
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        'معلومات الحساب',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ElMessiri',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      key: ValueKey(rebuildFlag), // هنا يتم تغيير المفتاح
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: info.length,
                      itemBuilder: (context, index) {
                        return UserInfoWidget(
                          inf0: info[index],
                          onChanged: () async {
                            await getData(); // <-- تحدث البيانات بعد التعديل من داخل كل ويدجت
                            setState(() {});
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.question,
                                animType: AnimType.rightSlide,
                                title: 'تنبـيـه',
                                titleTextStyle: const TextStyle(
                                  fontFamily: 'ElMessiri',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffff6e00),
                                ),
                                desc: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                                descTextStyle: const TextStyle(
                                  fontFamily: 'ElMessiri',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2b888e),
                                ),
                                btnOkText: 'نـعـم',
                                btnCancelText: 'لا',
                                btnOkOnPress: () async {
                                  try {
                                    GoogleSignIn googleSignIn = GoogleSignIn();
                                    googleSignIn.disconnect();
                                    await FirebaseAuth.instance.signOut();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            'signIn', (route) => false);
                                  } catch (e) {
                                    debugPrint('Error during sign out: $e');
                                  }
                                },
                                btnCancelOnPress: () {},
                              ).show();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              backgroundColor:
                                  const Color.fromARGB(255, 207, 241, 243),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                fontFamily: 'ElMessiri',
                                color: Color.fromARGB(255, 201, 40, 28),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Center(
                          child: Container(
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
                                showEditDialog(context);
                                await getData();
                                if (!mounted) return; // ✅ إضافة هذا الشرط
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 5,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'تعديل البيانات',
                                style: TextStyle(
                                  fontFamily: 'ElMessiri',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ), // <-- إغلاق الـ ListView
      ),
    );
  }

  void showEditDialog(BuildContext context) {
    final TextEditingController firstNameController =
        TextEditingController(text: userData?['firstName'] ?? '');
    final TextEditingController lastNameController =
        TextEditingController(text: userData?['lastName'] ?? '');
    final TextEditingController ageController =
        TextEditingController(text: userData?['age']?.toString() ?? '');
    // final TextEditingController selectedGender =
    //     TextEditingController(text: userData?['gender'] ?? '');
    String? selectedGender;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: const Text(
              'تعديل البيانات',
              style: TextStyle(fontFamily: 'ElMessiri'),
            ),
          ),
          content: SizedBox(
            height: 300,
            width: double.infinity, // <-- Add width to ensure layout
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  EditInfo(
                    controller: firstNameController,
                    label: 'الاسم الأول',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  EditInfo(
                    controller: lastNameController,
                    label: 'الاسم الأخير',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  EditInfo(
                    controller: ageController,
                    label: 'العمر',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
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
                      // prefixIcon: Icon(Icons.wc, color: Colors.pinkAccent),
                    ),
                    validator: (value) =>
                        value == null ? 'يرجى تحديد الجنس' : null,
                  ),
                ],
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
                  fontSize: 16,
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
                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'firstName': firstNameController.text.trim(),
                        'lastName': lastNameController.text.trim(),
                        'age': int.tryParse(ageController.text) ?? 0,
                        'gender': selectedGender,
                      });

                      setState(() {
                        userData?['firstName'] =
                            firstNameController.text.trim();
                        userData?['lastName'] = lastNameController.text.trim();
                        userData?['age'] =
                            int.tryParse(ageController.text) ?? 0;
                        userData?['gender'] = selectedGender;
                        rebuildFlag++;
                      });

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('حدث خطأ أثناء التعديل: $e'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ElMessiri',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
