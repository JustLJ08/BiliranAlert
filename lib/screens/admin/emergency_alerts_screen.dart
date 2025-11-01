import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:biliran_alert/utils/theme.dart';
import 'package:biliran_alert/utils/gradient_background.dart';

class EmergencyAlertsScreen extends StatefulWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  State<EmergencyAlertsScreen> createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _imageFile;
  Uint8List? _webImage;
  String _selectedSeverity = "low";

  String cloudinaryUploadUrl = "https://api.cloudinary.com/v1_1/dcqlmbxbi/image/upload";
  String uploadPreset = "biliran_unsigned";

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown time";
    final dateTime = timestamp.toDate();
    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  Future<String?> _uploadToCloudinary() async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl))
        ..fields['upload_preset'] = uploadPreset;

      if (kIsWeb && _webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          _webImage!,
          filename: 'alert.jpg',
        ));
      } else if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final url = RegExp(r'"secure_url":"([^"]+)"').firstMatch(resBody)?.group(1);
        return url;
      } else {
        print("Cloudinary upload failed: $resBody");
        return null;
      }
    } catch (e) {
      print("Cloudinary error: $e");
      return null;
    }
  }

  Future<void> _showAlertDialog({DocumentSnapshot? doc}) async {
    bool isEditing = doc != null;
    if (isEditing) {
      final data = doc.data() as Map<String, dynamic>;
      _locationController.text = data['location'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _selectedSeverity = data['severity'] ?? 'low';
      _imageFile = null;
      _webImage = null;
    } else {
      _locationController.clear();
      _descriptionController.clear();
      _selectedSeverity = 'low';
      _imageFile = null;
      _webImage = null;
    }

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setStateDialog) {
        // Web/Mobile image preview
        Widget imagePreview = Container(
          width: double.infinity,
          height: 150,
          color: Colors.grey[200],
          child: kIsWeb
              ? (_webImage != null
                  ? Image.memory(_webImage!, fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.camera_alt, size: 50)))
              : (_imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.camera_alt, size: 50))),
        );

        return AlertDialog(
          title: Text(isEditing ? "Edit Alert" : "Add Alert"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 8),
                imagePreview,
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _pickImage(ImageSource.camera);
                          setStateDialog(() {});
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Camera"),
                        style: ElevatedButton.styleFrom(backgroundColor: primaryDarkBlue),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await _pickImage(ImageSource.gallery);
                          setStateDialog(() {});
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Gallery"),
                        style: ElevatedButton.styleFrom(backgroundColor: accentOrange),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSeverity,
                  items: const [
                    DropdownMenuItem(value: "low", child: Text("Low")),
                    DropdownMenuItem(value: "moderate", child: Text("Moderate")),
                    DropdownMenuItem(value: "heavy", child: Text("Heavy")),
                  ],
                  onChanged: (value) => setStateDialog(() => _selectedSeverity = value!),
                  decoration: const InputDecoration(labelText: "Severity"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (_locationController.text.isEmpty || _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                String? imageUrl;
                if (_imageFile != null || _webImage != null) {
                  imageUrl = await _uploadToCloudinary();
                } else if (isEditing) {
                  final data = doc.data() as Map<String, dynamic>;
                  imageUrl = data['image_url'];
                }

                if (isEditing) {
                  await FirebaseFirestore.instance.collection('reports').doc(doc.id).update({
                    'location': _locationController.text.trim(),
                    'description': _descriptionController.text.trim(),
                    'severity': _selectedSeverity,
                    'image_url': imageUrl ?? '',
                  });
                } else {
                  await FirebaseFirestore.instance.collection('reports').add({
                    'location': _locationController.text.trim(),
                    'description': _descriptionController.text.trim(),
                    'severity': _selectedSeverity,
                    'image_url': imageUrl ?? '',
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? "Update" : "Add"),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _deleteAlert(String docId) async {
    await FirebaseFirestore.instance.collection('reports').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Alerts"),
        backgroundColor: primaryDarkBlue,
        centerTitle: true,
      ),
      body: GradientBackground(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reports')
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
                  "🚨 No active alerts.",
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              );
            }

            final incidents = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                final data = incident.data() as Map<String, dynamic>? ?? {};

                final imageUrl = data['image_url'] ?? '';
                final description = data['description'] ?? 'No description';
                final location = data['location'] ?? 'Unknown location';
                final timestamp = _formatTimestamp(data['timestamp']);
                final severity = data['severity'] ?? 'low';

                Color severityColor;
                switch (severity) {
                  case 'moderate':
                    severityColor = Colors.orange;
                    break;
                  case 'heavy':
                    severityColor = Colors.red;
                    break;
                  default:
                    severityColor = Colors.green;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
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
                                color: primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(timestamp, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: severityColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        severity.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () => _showAlertDialog(doc: incident),
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteAlert(incident.id),
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAlertDialog(),
        backgroundColor: primaryDarkBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
