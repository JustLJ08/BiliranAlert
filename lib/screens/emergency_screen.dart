import 'package:flutter/material.dart';
import 'package:biliran_alert/utils/theme.dart'; // ✅ for gradient colors

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> contacts = [
      {"agency": "Police Department", "number": "166"},
      {"agency": "Fire Department", "number": "160"},
      {"agency": "Ambulance", "number": "16911"},
      {"agency": "Local DRRMO", "number": "12345"},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true, // ✅ Allow gradient behind AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '🚨 Emergency Contacts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                color: Colors.white.withOpacity(0.15), // ✅ Semi-transparent
                elevation: 6,
                shadowColor: Colors.black26,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.local_phone_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  title: Text(
                    contact['agency']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "Hotline: ${contact['number']}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.greenAccent),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Calling ${contact['agency']}..."),
                        ),
                      );
                    },
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
