import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biliran_alert/utils/theme.dart';
import 'package:biliran_alert/screens/auth/auth_onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _municipalityController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController();

  String _gender = "Male";
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _emailController.text = doc['email'] ?? '';
          _addressController.text = doc['address'] ?? '';
          _contactController.text = doc['contact'] ?? '';
          _municipalityController.text = doc['municipality'] ?? '';
          _barangayController.text = doc['barangay'] ?? '';
          _gender = doc['gender'] ?? 'Male';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("users").doc(user.uid).update({
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
      "contact": _contactController.text.trim(),
      "municipality": _municipalityController.text.trim(),
      "barangay": _barangayController.text.trim(),
      "gender": _gender,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Profile updated successfully!")),
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthOnboardingScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('👤 Profile'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                if (_isEditing) {
                  _updateUserData();
                } else {
                  setState(() => _isEditing = true);
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryDarkBlue, accentOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 70, color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        _nameController.text.isEmpty
                            ? "No Name Set"
                            : _nameController.text,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: textLight, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        _emailController.text,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 30),

                      _buildEditableField(
                        controller: _nameController,
                        label: "Full Name",
                        icon: Icons.person,
                      ),
                      _buildEditableField(
                        controller: _addressController,
                        label: "Address",
                        icon: Icons.location_on,
                      ),
                      _buildEditableField(
                        controller: _municipalityController,
                        label: "Municipality",
                        icon: Icons.location_city,
                      ),
                      _buildEditableField(
                        controller: _barangayController,
                        label: "Barangay",
                        icon: Icons.location_disabled_rounded,
                      ),
                      _buildEditableField(
                        controller: _contactController,
                        label: "Contact Number",
                        icon: Icons.phone,
                      ),
                      _buildGenderDropdown(),

                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: warningRed,
                            foregroundColor: textLight,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // 🔹 Editable Input Field
  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: _isEditing
            ? TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              )
            : Text(
                controller.text.isEmpty ? "Not set" : controller.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }

  // 🔹 Gender Dropdown
  Widget _buildGenderDropdown() {
    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.wc, color: Colors.white),
        title: _isEditing
            ? DropdownButtonFormField<String>(
                value: _gender,
                dropdownColor: Colors.blueGrey[800],
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                  DropdownMenuItem(value: "Other", child: Text("Other")),
                ],
                onChanged: (value) => setState(() => _gender = value!),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Gender",
                  labelStyle: TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
              )
            : Text(
                _gender,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
