import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:raie/auth/sign_in.dart';
import 'package:raie/auth/sign_up.dart';
import 'package:raie/models/unit_model.dart';
import 'package:raie/screens/about_screen.dart';
import 'package:raie/screens/home_Screen.dart';
import 'package:raie/screens/splash_screen.dart';
import 'package:raie/screens/user_profile_screen.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(MeasurementAdapter());

  await Hive.openBox<List>('historyBox');
  runApp(
    OverlaySupport.global(
      child: RaieApp(),
    ),
  );
}

class RaieApp extends StatefulWidget {
  const RaieApp({super.key});

  @override
  State<RaieApp> createState() => _RaieAppState();
}

class _RaieAppState extends State<RaieApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('===========User is currently signed out!');
      } else {
        print('===========User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // builder: (_, child) {
      //   return Directionality(
      //     textDirection: TextDirection.rtl,   --[لجعل اتجاه التطبيق من اليمين لليسار]--
      //     child: child!,
      //   );
      // },
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Life Guard',
      theme: ThemeData(
        primaryColor: const Color(0xff1e8083),
      ),
      home: SplashScreen(),
      routes: {
        "homeScreen": (context) => HomeScreen(),
        "signIn": (context) => SignIn(),
        "signUp": (context) => SignUp(),
        "profile": (context) => UserProfileScreen(),
        "about": (context) => AboutScreen(),
      },
    );
  }
}
