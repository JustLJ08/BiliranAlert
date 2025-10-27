import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 must exist
import 'package:biliran_alert/screens/citizen/splash_screen.dart';
import 'package:biliran_alert/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 👇 Paste it right here
  print("✅ Firebase connected successfully!");

  runApp(const BiliranAlertApp());
}

class BiliranAlertApp extends StatelessWidget {
  const BiliranAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiliranAlert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.disasterTheme,
      home: const SplashScreen(),
    );
  }
}
