import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Needed for AnnotatedRegion & SystemUiOverlayStyle
import 'package:biliran_alert/utils/theme.dart';
import 'package:biliran_alert/screens/auth_onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // ✅ remove status bar background
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        extendBodyBehindAppBar: true, // ✅ ensures seamless gradient behind appbar

        appBar: AppBar(
          title: const Text('👤 Profile'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent, // ✅ removes subtle overlay
          elevation: 0,
          scrolledUnderElevation: 0, // ✅ no line when scrolling
        ),

        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryDarkBlue, accentOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            top: false, // ✅ ensures gradient fills behind status bar
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 80), // pushes content below app bar

                    // --- Profile Header ---
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Juan Dela Cruz",
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: textLight,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "juan.delacruz@example.com",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      "Resident of Biliran, Philippines",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // --- Profile Details in Boxes ---
                    _buildProfileDetailBox(
                        context, Icons.phone, "+63 912 345 6789"),
                    _buildProfileDetailBox(context, Icons.location_on,
                        "Barangay San Jose, Naval"),

                    const SizedBox(height: 40),

                    Text(
                      "\"Stay safe and alert, always be prepared!\"",
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic,
                              ),
                    ),
                    const SizedBox(height: 60),

                    // --- Logout Button ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AuthOnboardingScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warningRed,
                          foregroundColor: textLight,
                          padding:
                              const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Box Widget for Profile Details
  Widget _buildProfileDetailBox(
      BuildContext context, IconData icon, String text) {
    return Card(
      color: Colors.white.withOpacity(0.15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style:
              Theme.of(context).textTheme.bodyLarge?.copyWith(color: textLight),
        ),
      ),
    );
  }
}
