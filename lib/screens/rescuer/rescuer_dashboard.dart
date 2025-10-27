import 'package:flutter/material.dart';
import 'package:biliran_alert/utils/theme.dart';

class RescuerDashboard extends StatelessWidget {
  const RescuerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkBlue,
      appBar: AppBar(
        title: const Text('Rescuer Dashboard'),
        backgroundColor: accentOrange,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety, color: Colors.white, size: 100),
            const SizedBox(height: 20),
            Text(
              'Welcome, Rescuer!',
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
