import 'package:flutter/material.dart';
import 'safety_screen.dart';
import 'emergency_screen.dart';
import 'profile_screen.dart';
import 'package:biliran_alert/widgets/bottom_nav.dart';
import 'package:biliran_alert/utils/theme.dart'; // for gradient colors

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    SafetyScreen(),
    EmergencyScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Important: allows gradient to extend behind the bottom nav
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "color": Colors.redAccent,
        "icon": Icons.warning_amber_rounded,
        "title": "Emergency Alerts",
        "subtitle": "View active alerts and warnings",
        "onTap": () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Emergency Alerts...")),
          );
        },
      },
      {
        "color": Colors.orangeAccent,
        "icon": Icons.report_problem_rounded,
        "title": "Report Incident",
        "subtitle": "Report disasters and emergencies",
        "onTap": () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Report Incident...")),
          );
        },
      },
      {
        "color": Colors.green,
        "icon": Icons.location_on_rounded,
        "title": "Evacuation Centers",
        "subtitle": "Find nearest evacuation centers",
        "onTap": () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Evacuation Centers...")),
          );
        },
      },
      {
        "color": Colors.purpleAccent,
        "icon": Icons.medical_services_rounded,
        "title": "First Aid Guide",
        "subtitle": "Emergency medical procedures",
        "onTap": () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening First Aid Guide...")),
          );
        },
      },
      {
        "color": Colors.purpleAccent,
        "icon": Icons.medical_services_rounded,
        "title": "About Us",
        "subtitle": "Made by Harold Abogado",
        "onTap": () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening About Us...")),
          );
        },
      },
    ];

    return Container(
      // ✅ Gradient directly applied to root container
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryDarkBlue, accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false, // ✅ Avoids pushing content up (no white gap)
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "BiliranAlert",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: item["onTap"],
                        child: Container(
                          decoration: BoxDecoration(
                            color: item["color"],
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: item["color"].withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(item["icon"],
                                      color: Colors.white, size: 36),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item["subtitle"],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
