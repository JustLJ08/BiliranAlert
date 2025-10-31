import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screens
import 'report_screen.dart';
import 'emergency_alerts_screen.dart';
import 'about_us_screen.dart';
import 'first_aid_guide_screen.dart';
import 'evacuation_centers_screen.dart';
import 'contacts_screen.dart';
import 'profile_screen.dart';

// Widgets
import 'package:biliran_alert/widgets/bottom_nav.dart';

// Theme
import 'package:biliran_alert/utils/theme.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    ContactsScreen(),
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryDarkBlue, accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "DasigAlert",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // 🔴 Emergency Alerts card with real-time badge
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('incidents')
                          .snapshots(),
                      builder: (context, snapshot) {
                        int count =
                            snapshot.hasData ? snapshot.data!.docs.length : 0;

                        return _buildMenuCard(
                          context,
                          color: Colors.redAccent,
                          icon: Icons.warning_amber_rounded,
                          title: "Emergency Alerts",
                          subtitle: "View active alerts and warnings",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EmergencyAlertsScreen(),
                              ),
                            );
                          },
                          badgeCount: count,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildMenuCard(
                      context,
                      color: Colors.orangeAccent,
                      icon: Icons.camera_alt,
                      title: "Report Incident",
                      subtitle: "Report disasters and emergencies",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReportScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildMenuCard(
                      context,
                      color: Colors.green,
                      icon: Icons.location_on_rounded,
                      title: "Evacuation Centers",
                      subtitle: "Find nearest evacuation centers",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EvacuationCentersScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildMenuCard(
                      context,
                      color: Colors.purpleAccent,
                      icon: Icons.medical_services_rounded,
                      title: "First Aid Guide",
                      subtitle: "Emergency medical procedures",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FirstAidGuideScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildMenuCard(
                      context,
                      color: Colors.blueAccent,
                      icon: Icons.info_rounded,
                      title: "About Us",
                      subtitle: "Learn more about this app",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutUsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left section (icon + text)
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon, color: Colors.white, size: 36),
                    if (badgeCount > 0)
                      Positioned(
                        // ✅ repositioned for perfect alignment
                        right: -6,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: warningRed,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              badgeCount > 9 ? "9+" : "$badgeCount",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
