import 'package:flutter/material.dart';
import 'package:biliran_alert/screens/auth_onboarding_screen.dart';
import 'package:biliran_alert/utils/theme.dart'; // ✅ Import to access theme colors

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Delay before navigating to onboarding screen
    Future.delayed(const Duration(seconds: 3), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthOnboardingScreen(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🎨 Gradient background (same as onboarding)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryDarkBlue, accentOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🖼️ App Logo
              const Image(
                image: AssetImage("lib/assets/images/systemlogo.jpg"),
                height: 180,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // 📝 App Name Text
              const Text(
                'BiliranAlert',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 50),

              // 🔄 Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
