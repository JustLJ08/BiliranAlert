import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B0CA0), // Deep Purple
            Color(0xFFE85D04), // Orange
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            // ✅ Extra layer to fully cover anti-alias white gap
            Positioned.fill(
              top: -2, // <— increased from -1 to -2 to hide seam completely
              child: Container(
                color: Colors.transparent,
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  currentIndex: selectedIndex,
                  onTap: onItemTapped,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.health_and_safety_rounded),
                      label: 'Safety',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.medical_services_rounded),
                      label: 'Emergency',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_rounded),
                      label: 'Profile',
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
}
