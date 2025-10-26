import 'package:flutter/material.dart';
import 'package:biliran_alert/screens/splash_screen.dart';
import 'package:biliran_alert/utils/theme.dart'; // Import the new theme file

void main() {
  runApp(const BiliranAlertApp());
}

class BiliranAlertApp extends StatelessWidget {
  const BiliranAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiliranAlert',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.disasterTheme, // <--- Now using the new disaster theme
      home: const SplashScreen(),
    );
  }
}