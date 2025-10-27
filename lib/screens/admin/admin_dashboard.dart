import 'package:flutter/material.dart';
import 'package:biliran_alert/utils/theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkBlue,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: accentOrange,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, color: Colors.white, size: 100),
            const SizedBox(height: 20),
            Text(
              'Welcome, Admin!',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: textLight),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentOrange,
                foregroundColor: textLight,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
