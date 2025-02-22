import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/AddAdminScreen.dart';
import 'package:flutter_application_4/AdminScreen.dart';
import 'package:flutter_application_4/login_screen.dart';
import 'package:flutter_application_4/logout.dart';
import 'package:flutter_application_4/welcome_screen.dart';

void main() async {
  // تهيئة Widgets وFirebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // تهيئة Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mutabie App', // اسم التطبيق
      initialRoute: '/', // المسار المبدئي للتطبيق
      routes: {
        '/': (context) => const WelcomeScreen(), // شاشة الترحيب
        '/login': (context) => LoginSchoolScreen(), // شاشة
        '/logout': (context) => LogoutScreen(), // شاشة تسجيل الخروج
        '/AddAdminScreen': (context) => AddAdminScreen(), // أضف هذا السطر
        '/AdminScreen': (context) => AdminListScreen(), // شاشة
      },
    );
  }
}
