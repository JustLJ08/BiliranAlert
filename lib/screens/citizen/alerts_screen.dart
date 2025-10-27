import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  final List<Map<String, String>> alerts = const [
    {
      "type": "Flood Warning",
      "location": "Biliran North",
      "time": "2:45 PM",
      "severity": "High"
    },
    {
      "type": "Typhoon Update",
      "location": "Signal #2 – Coastal Areas",
      "time": "11:30 AM",
      "severity": "Moderate"
    },
    {
      "type": "Fire Incident",
      "location": "Barangay Poblacion",
      "time": "8:12 AM",
      "severity": "Low"
    },
  ];

  Color getSeverityColor(String level) {
    switch (level) {
      case 'High':
        return Colors.red;
      case 'Moderate':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📢 Disaster Alerts'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.warning_amber_rounded,
                color: getSeverityColor(alert["severity"]!),
                size: 36,
              ),
              title: Text(
                alert["type"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "${alert["location"]}\nTime: ${alert["time"]} | Severity: ${alert["severity"]}",
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
