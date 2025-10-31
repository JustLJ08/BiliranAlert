import 'package:flutter/material.dart';
import 'package:biliran_alert/utils/theme.dart'; // ✅ Uses your existing color theme

class EvacuationCentersScreen extends StatefulWidget {
  const EvacuationCentersScreen({super.key});

  @override
  State<EvacuationCentersScreen> createState() => _EvacuationCentersScreenState();
}

class _EvacuationCentersScreenState extends State<EvacuationCentersScreen> {
  final List<Map<String, String>> evacuationCenters = [
    {
      'name': 'Naval Gymnasium',
      'location': 'P. Inocentes St., Naval, Biliran',
      'capacity': '500 people'
    },
    {
      'name': 'Naval Central School',
      'location': 'Santissimo Rosario St., Naval, Biliran',
      'capacity': '350 people'
    },
    {
      'name': 'BiPsu Gymnasium',
      'location': 'Biliran Province State University, Naval, Biliran',
      'capacity': '600 people'
    },
    {
      'name': 'Brgy. Larrazabal Covered Court',
      'location': 'Larrazabal, Naval, Biliran',
      'capacity': '200 people'
    },
    {
      'name': 'Brgy. Caraycaray Multi-purpose Hall',
      'location': 'Caraycaray, Naval, Biliran',
      'capacity': '250 people'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Evacuation Centers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryDarkBlue, // ✅ Matches theme
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
            itemCount: evacuationCenters.length,
            itemBuilder: (context, index) {
              final center = evacuationCenters[index];
              return Card(
                color: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.location_city_rounded,
                    color: accentOrange,
                    size: 36,
                  ),
                  title: Text(
                    center['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryDarkBlue,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        center['location']!,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Capacity: ${center['capacity']}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: primaryDarkBlue,
                    size: 20,
                  ),
                  onTap: () {
                    _showCenterDetails(context, center);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCenterDetails(BuildContext context, Map<String, String> center) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            center['name']!,
            style: const TextStyle(
              color: primaryDarkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on_rounded, color: accentOrange),
                  SizedBox(width: 8),
                  Text("Location:"),
                ],
              ),
              Text(
                center['location']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.people_alt_rounded, color: accentOrange),
                  SizedBox(width: 8),
                  Text("Capacity:"),
                ],
              ),
              Text(
                center['capacity']!,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(color: accentOrange, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
