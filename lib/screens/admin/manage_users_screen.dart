import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biliran_alert/utils/theme.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> myTabs = const [
    Tab(text: "Pending Rescuers"),
    Tab(text: "Rescuers"),
    Tab(text: "Citizens"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _approveUser(String userId) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Approve Rescuer"),
        content:
            const Text("Are you sure you want to approve this responder?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Immediately update Firestore
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .update({
                "verification": "verified",
                "status": "approved",
              });

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Responder approved successfully")),
                );
              }
            },
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(String role, {bool onlyPending = false}) {
    Query userQuery = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role);

    // Filter users based on verification status
    if (onlyPending) {
      userQuery = userQuery.where('verification', isEqualTo: 'pending');
    } else if (role == "rescuer") {
      userQuery = userQuery.where('verification', isEqualTo: 'verified');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: userQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              onlyPending
                  ? "No pending rescuers."
                  : "No $role found.",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final verification = userData['verification'] ?? '';
            final firstName = userData['firstName'] ?? '';
            final lastName = userData['lastName'] ?? '';
            final email = userData['email'] ?? '';
            final barangay = userData['barangay'] ?? '';
            final userRole = userData['role'] ?? '';

            // Status button for rescuer
            Widget statusButton() {
              if (verification == "pending") {
                return GestureDetector(
                  onTap: () => _approveUser(users[index].id),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade700),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.hourglass_empty,
                            color: Colors.orange, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "PENDING",
                          style: TextStyle(
                              color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.verified, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "VERIFIED",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }
            }

            return Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text("$firstName $lastName"),
                subtitle: Text("$email • $userRole • $barangay"),
                trailing: role == "rescuer" ? statusButton() : null,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: accentOrange,
                unselectedLabelColor: primaryDarkBlue,
                tabs: myTabs,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Pending Rescuers tab
                  _buildUserList("rescuer", onlyPending: true),
                  // Rescuers tab: only VERIFIED
                  _buildUserList("rescuer", onlyPending: false),
                  // Citizens tab
                  _buildUserList("citizen"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
