import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screens
import 'report_screen.dart';
import 'view_reports_screen.dart';
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

class ResponderDashboard extends StatefulWidget {
  final String responderId;

  const ResponderDashboard({super.key, required this.responderId});

  @override
  State<ResponderDashboard> createState() => _ResponderDashboardState();
}

class _ResponderDashboardState extends State<ResponderDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ResponderHomeContent(),
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

class MenuItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final Widget screen;
  final String? firestoreCollection;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.screen,
    this.firestoreCollection,
  });
}

class ResponderHomeContent extends StatelessWidget {
  const ResponderHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Menu items
    final List<MenuItem> menuItems = [
      MenuItem(
        title: "Emergency Alerts",
        subtitle: "View active alerts and warnings",
        color: Colors.redAccent,
        icon: Icons.warning_amber_rounded,
        screen: const EmergencyAlertsScreen(),
        firestoreCollection: 'reports', // live badge
      ),
      MenuItem(
        title: "View Reports",
        subtitle: "Check submitted incident reports",
        color: Colors.deepOrange,
        icon: Icons.list_alt_rounded,
        screen: const ViewReportsScreen(),
        firestoreCollection: 'incidents', // live badge
      ),
      MenuItem(
        title: "Report Incident",
        subtitle: "Report disasters and emergencies",
        color: Colors.orangeAccent,
        icon: Icons.camera_alt,
        screen: const ReportScreen(),
      ),
      MenuItem(
        title: "Evacuation Centers",
        subtitle: "Find nearest evacuation centers",
        color: Colors.green,
        icon: Icons.location_on_rounded,
        screen: const EvacuationCentersScreen(),
      ),
      MenuItem(
        title: "First Aid Guide",
        subtitle: "Emergency medical procedures",
        color: Colors.purpleAccent,
        icon: Icons.medical_services_rounded,
        screen: const FirstAidGuideScreen(),
      ),
      MenuItem(
        title: "About Us",
        subtitle: "Learn more about this app",
        color: Colors.blueAccent,
        icon: Icons.info_rounded,
        screen: const AboutUsScreen(),
      ),
    ];

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
              "DasigAlert Responder",
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
                  children: menuItems.map((item) {
                    if (item.firestoreCollection != null) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(item.firestoreCollection!)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final int count =
                              snapshot.hasData ? snapshot.data!.docs.length : 0;
                          return Column(
                            children: [
                              _buildMenuCard(
                                context,
                                color: item.color,
                                icon: item.icon,
                                title: item.title,
                                subtitle: item.subtitle,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => item.screen),
                                ),
                                badgeCount: count,
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          _buildMenuCard(
                            context,
                            color: item.color,
                            icon: item.icon,
                            title: item.title,
                            subtitle: item.subtitle,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => item.screen),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                  }).toList(),
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
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(icon, color: Colors.white, size: 36),
                    if (badgeCount > 0)
                      Positioned(
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
