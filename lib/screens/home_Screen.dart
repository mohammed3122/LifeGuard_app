import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:raie/screens/about_screen.dart';
import 'package:raie/views/cards_view.dart';
import 'package:raie/views/units_view.dart';
import 'package:raie/widgets/dialog_ode.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // إعداد AnimationController لتكرار الأنيميشن
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(); // جعل الأنيميشن يتكرر باستمرار

    // إعداد التدرج المتحرك
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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

      showOverlay(
        (context, t) {
          final animation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: AlwaysStoppedAnimation(t),
              curve: Curves.easeOut,
            ),
          );

          return SlideTransition(
            position: animation,
            child: Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.only(top: 91, right: 70),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF339cd2), // الأزرق
                        Color(0xFF2fc57f), // الأخضر
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Text(
                    'أهلاً بيك يا ${userData?['firstName'] ?? ''} 👋',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'ElMessiri',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
          );
        },
        duration: Duration(seconds: 3),
      );
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // التأكد من تدمير الـ Controller عند الخروج من الـ Widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            );
          },
        ),
        title: Text(
          'Life Guard',
          style: TextStyle(
            fontFamily: 'ElMessiri',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xff2b888e),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/users/user.webp'),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          CardView(),
          SizedBox(
            height: 20,
          ),
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
                'قياساتك',
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
          UnitsView(),
          Text(
            'Life Guard مش صحيح 100% فراجع الطبيب باستمرار',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'ElMessiri',
              fontSize: 14,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30, top: 10),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xff34b7fe), // أزرق
                      Color(0xff25d366), // أخضر
                    ],
                    begin: Alignment(
                        -1 + 2 * _animation.value, -1 + 2 * _animation.value),
                    end: Alignment(
                        1 - 2 * _animation.value, 1 - 2 * _animation.value),
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showOdeDialog(context);
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        AssetImage('assets/images/icons/ode_face.webp'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
