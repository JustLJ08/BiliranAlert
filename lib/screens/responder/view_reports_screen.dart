import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:biliran_alert/utils/theme.dart';
import 'package:biliran_alert/utils/gradient_background.dart';

class ViewReportsScreen extends StatelessWidget {
  const ViewReportsScreen({super.key});

  // Format Firestore Timestamp
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown time";
    final dateTime = timestamp.toDate();
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  // Update Firestore status
  Future<void> _updateStatus(
    BuildContext context,
    String docId,
    String currentStatus,
  ) async {
    final statuses = ["pending","in_progress", "resolved"];

    await showDialog(
      context: context,
      builder: (context) {
        String selectedStatus =
            statuses.contains(currentStatus) ? currentStatus : statuses.first;

        return AlertDialog(
          title: const Text(
            "Update Report Status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: "Select new status",
                  border: OutlineInputBorder(),
                ),
                items: statuses
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedStatus = value);
                  }
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDarkBlue,
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('incidents') // <-- reports collection
                    .doc(docId)
                    .update({'status': selectedStatus});

                if (!context.mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Status updated to ${selectedStatus.toUpperCase()}",
                    ),
                    backgroundColor: primaryDarkBlue,
                  ),
                );
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "Incident Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryDarkBlue,
      ),
      body: GradientBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('incidents') // <-- reports collection
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryDarkBlue),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "🚨 No reports yet.",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              );
            }

            final reports = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                final data = report.data() as Map<String, dynamic>? ?? {};

                final imageUrl = data['image_url'] ?? '';
                final description = data['description'] ?? 'No description';
                final location = data['location'] ?? 'Unknown location';
                final timestamp = _formatTimestamp(data['timestamp']);
                final status = (data['status'] ?? 'pending').toString();

                // Status color & icon
                late final Color statusColor;
                late final IconData statusIcon;

                switch (status) {
                  case 'resolved':
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'in_progress':
                    statusColor = Colors.blue;
                    statusIcon = Icons.autorenew;
                    break;
                  case 'acknowledged':
                    statusColor = Colors.orange;
                    statusIcon = Icons.assignment_turned_in;
                    break;
                  default:
                    statusColor = accentOrange;
                    statusIcon = Icons.warning_amber_rounded;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: primaryDarkBlue.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryDarkBlue),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: primaryDarkBlue),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: Colors.grey, size: 18),
                                    const SizedBox(width: 4),
                                    Text(timestamp,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(statusIcon, color: statusColor, size: 18),
                                      const SizedBox(width: 4),
                                      Text(status.toUpperCase(),
                                          style: TextStyle(
                                              color: statusColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text("Update Status"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryDarkBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () =>
                                    _updateStatus(context, report.id, status),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
