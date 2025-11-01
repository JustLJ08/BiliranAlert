import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biliran_alert/screens/citizen/home_dashboard.dart';
import 'package:biliran_alert/utils/theme.dart';
import 'package:biliran_alert/screens/admin/admin_dashboard.dart';
import 'package:biliran_alert/screens/responder/responder_dashboard.dart';

class AuthOnboardingScreen extends StatefulWidget {
  const AuthOnboardingScreen({super.key});

  @override
  State<AuthOnboardingScreen> createState() => _AuthOnboardingScreenState();
}

class _AuthOnboardingScreenState extends State<AuthOnboardingScreen> {
  final PageController _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // Dropdown selections
  String _selectedRole = "citizen";
  String _selectedGender = "Male";
  String _selectedBarangay = "Agpangi";

  final List<String> barangays = [
    "Agpangi",
    "Anislagan",
    "Atipolo",
    "Calumpang",
    "Cabungaan",
    "Larazabal",
    "Sabang",
    "Caray-caray",
  ];

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // --- Sign Up Function ---
  Future<void> _signUp() async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Determine initial verification & status
      String verification = _selectedRole == "rescuer" ? "pending" : "verified";
      String status = _selectedRole == "rescuer" ? "pending" : "approved";

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "firstName": _firstnameController.text.trim(),
        "lastName": _lastnameController.text.trim(),
        "email": _emailController.text.trim(),
        "role": _selectedRole,
        "address": _addressController.text.trim(),
        "contact": _contactController.text.trim(),
        "gender": _selectedGender,
        "municipality": "Naval", // fixed municipality
        "barangay": _selectedBarangay,
        "createdAt": FieldValue.serverTimestamp(),
        "status": status,
        "verification": verification,
      });

      if (_selectedRole == "rescuer") {
        _showSnackBar(
            "Rescuer account created. Please wait for admin approval.");
        _navigateToPage(0); // back to landing
      } else {
        _redirectToDashboard(_selectedRole);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar("Auth Error: ${e.message}");
    } catch (e) {
      _showSnackBar("Unexpected error: $e");
    }
  }

  // --- Login Function ---
  Future<void> _login() async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userDoc =
          await _firestore.collection("users").doc(credential.user!.uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        String verification = userDoc['verification'] ?? 'verified';

        // Prevent rescuer from logging in if pending
        if (role == "rescuer" && verification != "verified") {
          _showSnackBar(
              "Your account is pending approval. Please wait for admin approval.");
          await _auth.signOut();
          return;
        }

        _redirectToDashboard(role);
      } else {
        _showSnackBar("User role not found in Firestore.");
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar("Auth Error: ${e.message}");
    } catch (e) {
      _showSnackBar("Unexpected error: $e");
    }
  }

  // --- Redirect by Role ---
  void _redirectToDashboard(String role) {
    Widget destination;
    if (role == "admin") {
      destination = const AdminDashboard(adminId: '');
    } else if (role == "rescuer") {
      destination = const ResponderDashboard(responderId: '');
    } else {
      destination = const HomeDashboard();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryDarkBlue, accentOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildLandingPage(context),
            _buildLoginPage(context),
            _buildSignUpPage(context),
          ],
        ),
      ),
    );
  }

  // --- Landing Page ---
  Widget _buildLandingPage(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 380,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("lib/assets/images/systemlogo.jpg", height: 170),
              const SizedBox(height: 20),
              Text(
                'BiliranAlert',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: primaryDarkBlue, fontSize: 36),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _navigateToPage(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: textLight,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _navigateToPage(2),
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentOrange,
                  side: const BorderSide(color: accentOrange, width: 2),
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Login Page ---
  Widget _buildLoginPage(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => _navigateToPage(0),
                  icon: const Icon(Icons.arrow_back, color: accentOrange),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome Back!',
                style: TextStyle(
                    color: accentOrange,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentOrange,
                  foregroundColor: textLight,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _navigateToPage(2),
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: accentOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Sign Up Page ---
  Widget _buildSignUpPage(BuildContext context) {
    return Center(
      child: Container(
        width: 380,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => _navigateToPage(0),
                  icon: const Icon(Icons.arrow_back, color: accentOrange),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create Your Alert Account',
                style: TextStyle(
                    color: accentOrange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildSignUpFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpFields() {
    return Column(
      children: [
        TextField(
          controller: _firstnameController,
          decoration: const InputDecoration(
            hintText: 'First Name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _lastnameController,
          decoration: const InputDecoration(
            hintText: 'Last Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            hintText: 'Email Address',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Contact Number',
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            hintText: 'Street or Purok',
            prefixIcon: Icon(Icons.location_on),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedBarangay,
          items: barangays
              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
          onChanged: (value) => setState(() => _selectedBarangay = value!),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_city),
            labelText: "Select Barangay (Naval)",
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          items: const [
            DropdownMenuItem(value: "Male", child: Text("Male")),
            DropdownMenuItem(value: "Female", child: Text("Female")),
            DropdownMenuItem(value: "Other", child: Text("Other")),
          ],
          onChanged: (value) => setState(() => _selectedGender = value!),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.wc),
            labelText: "Select Gender",
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          items: const [
            DropdownMenuItem(value: "admin", child: Text("Admin")),
            DropdownMenuItem(value: "rescuer", child: Text("Responder")),
            DropdownMenuItem(value: "citizen", child: Text("Resident")),
          ],
          onChanged: (value) => setState(() => _selectedRole = value!),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.security),
            labelText: "Select Role",
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _signUp,
          style: ElevatedButton.styleFrom(
            backgroundColor: accentOrange,
            foregroundColor: textLight,
            minimumSize: const Size(double.infinity, 45),
          ),
          child: const Text('Sign Up'),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => _navigateToPage(1),
          child: const Text(
            "Already have an account? Login",
            style: TextStyle(color: accentOrange),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
