import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raie/screens/ode_ai_screen.dart';

Future<void> showOdeDialog(BuildContext context) async {
  Map<String, dynamic>? userData;

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

  if (context.mounted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _OdeDialogContent(userData: userData);
      },
    );
  }
}

class _OdeDialogContent extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const _OdeDialogContent({this.userData});

  @override
  State<_OdeDialogContent> createState() => _OdeDialogContentState();
}

class _OdeDialogContentState extends State<_OdeDialogContent>
    with TickerProviderStateMixin {
  late AnimationController _avatarController;

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: Tween(begin: 0.7, end: 1.0).animate(_avatarController),
                child: ScaleTransition(
                  scale:
                      Tween(begin: 0.9, end: 1.05).animate(_avatarController),
                  child: Container(
                    padding: const EdgeInsets.all(3), // سمك الإطار
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff34b7fe), Color(0xff25d366)],
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white, // خلفية بيضاء داخل الإطار
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/icons/ode_face.webp'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                textDirection: TextDirection.rtl,
                "أهلاً بيك يا ${widget.userData?['firstName'] ?? ''} 👋",
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xff29888d),
                  fontFamily: 'ElMessiri',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text.rich(
                TextSpan(
                  text: "أنا Ode.. مساعدك الصحي الذكي من فريق MoDev\n",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ElMessiri',
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                  children: [
                    TextSpan(
                      text: "موجود هنا علشان أساعدك في أي حاجة تخص صحتك.\n",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff29888d),
                      ),
                    ),
                    TextSpan(
                      text:
                          "لو حابب تسألني عن حالتك، دوس على ( تحدث معي ) وخلينا نبدأ سوا !",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 233, 152, 59),
                      ),
                    ),
                  ],
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'تِسلـم',
                      style: TextStyle(
                        fontFamily: 'ElMessiri',
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff38b6ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OdeAiChat();
                      }));
                    },
                    child: const Text(
                      "تحدث معي",
                      style: TextStyle(
                        fontFamily: 'ElMessiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
