import 'package:flutter/material.dart';
import 'package:biliran_alert/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  final List<Map<String, String>> contactList = const [
    {
      "name": "Biliran Provincial DRRM Office",
      "number": "0998 765 4321",
      "location": "Naval, Biliran"
    },
    {
      "name": "Municipal Fire Station",
      "number": "160",
      "location": "Naval, Biliran"
    },
    {
      "name": "PNP Biliran",
      "number": "0999 888 7777",
      "location": "Naval, Biliran"
    },
    {
      "name": "Naval Rescue Team",
      "number": "0917 654 3210",
      "location": "Biliran Province"
    },
    {
      "name": "Biliran Provincial Hospital",
      "number": "(053) 500-1234",
      "location": "Caraycaray, Naval"
    },
  ];

  Future<void> _launchDialer(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryDarkBlue, accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Emergency Contacts",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left section (icon + info)
                    Expanded(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: accentOrange,
                            child: Icon(Icons.phone, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact["name"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryDarkBlue,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  contact["location"]!,
                                  style:
                                      const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right section (number + button)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 95,
                          child: Text(
                            contact["number"]!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: accentOrange,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.call, size: 14),
                          label: const Text("Call", style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryDarkBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(70, 28),
                          ),
                          onPressed: () => _launchDialer(contact["number"]!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
