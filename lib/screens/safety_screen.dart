import 'package:flutter/material.dart';
import 'package:biliran_alert/utils/theme.dart'; // ✅ for gradient colors

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tips = [
      {
        "title": "Earthquake Safety",
        "desc": "Drop, cover, and hold on. Stay away from windows."
      },
      {
        "title": "Flood Preparedness",
        "desc": "Move to higher ground immediately and avoid floodwaters."
      },
      {
        "title": "Fire Safety",
        "desc": "Know your exits and have an extinguisher ready."
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true, // ✅ Allows gradient to go behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '🛡️ Safety Tips',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        // ✅ Same gradient background as Home
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryDarkBlue, accentOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Card(
                color: Colors.white.withOpacity(0.15), // ✅ Subtle transparency
                elevation: 6,
                shadowColor: Colors.black26,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.health_and_safety_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  title: Text(
                    tip["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    tip["desc"]!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
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
