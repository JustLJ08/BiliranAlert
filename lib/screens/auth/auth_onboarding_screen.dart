import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biliran_alert/screens/citizen/home_dashboard.dart';
import 'package:biliran_alert/utils/theme.dart';
import 'package:biliran_alert/screens/admin/admin_dashboard.dart';
import 'package:biliran_alert/screens/rescuer/rescuer_dashboard.dart';

class AuthOnboardingScreen extends StatefulWidget {
  const AuthOnboardingScreen({super.key});

  @override
  State<AuthOnboardingScreen> createState() => _AuthOnboardingScreenState();
}

class _AuthOnboardingScreenState extends State<AuthOnboardingScreen> {
  final PageController _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _selectedRole = "citizen"; // default role
  String _selectedGender = "Male";

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
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

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "role": _selectedRole,
        "address": _addressController.text.trim(),
        "contact": _contactController.text.trim(),
        "gender": _selectedGender,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _redirectToDashboard(_selectedRole);
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Sign Up failed");
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
        _redirectToDashboard(role);
      } else {
        _showSnackBar("User role not found.");
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Login failed");
    }
  }

  // --- Redirection Function ---
  void _redirectToDashboard(String role) {
    Widget destination;
    if (role == "admin") {
      destination = const AdminDashboard();
    } else if (role == "rescuer") {
      destination = const RescuerDashboard();
    } else {
      destination = const HomeDashboard();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  // --- Show SnackBar ---
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("lib/assets/images/systemlogo.jpg", height: 170),
          const SizedBox(height: 20),
          Text(
            'BiliranAlert',
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: textLight, fontSize: 36),
          ),
          const SizedBox(height: 80),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToPage(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: textLight,
                foregroundColor: primaryDarkBlue,
              ),
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _navigateToPage(2),
              style: OutlinedButton.styleFrom(
                foregroundColor: textLight,
                side: const BorderSide(color: textLight, width: 2),
              ),
              child: const Text('Sign Up'),
            ),
          ),
          const SizedBox(height: 80),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeDashboard()),
              );
            },
            child: Text(
              'Continue as a guest',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: textLight.withOpacity(0.9),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Login Page ---
  Widget _buildLoginPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          IconButton(
            onPressed: () => _navigateToPage(0),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: textLight),
            ),
          ),
          const SizedBox(height: 40),
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
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentOrange,
                foregroundColor: textLight,
              ),
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: TextButton(
              onPressed: () => _navigateToPage(2),
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Sign Up Page ---
  Widget _buildSignUpPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          IconButton(
            onPressed: () => _navigateToPage(0),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Create Your Alert Account',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: textLight),
            ),
          ),
          const SizedBox(height: 40),

          // --- Name Field ---
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Full Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),

          // --- Email Field ---
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),

          // --- Password Field ---
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 16),

          // --- Contact ---
          TextField(
            controller: _contactController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Contact Number',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 16),

          // --- Address ---
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: 'Address',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 16),

          // --- Gender ---
          DropdownButtonFormField<String>(
            value: _selectedGender,
            items: const [
              DropdownMenuItem(value: "Male", child: Text("Male")),
              DropdownMenuItem(value: "Female", child: Text("Female")),
              DropdownMenuItem(value: "Other", child: Text("Other")),
            ],
            onChanged: (value) {
              setState(() => _selectedGender = value!);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.wc),
              labelText: "Select Gender",
            ),
          ),
          const SizedBox(height: 16),

          // --- Role ---
          DropdownButtonFormField<String>(
            value: _selectedRole,
            items: const [
              DropdownMenuItem(value: "admin", child: Text("Admin")),
              DropdownMenuItem(value: "rescuer", child: Text("Rescuer")),
              DropdownMenuItem(value: "citizen", child: Text("Citizen")),
            ],
            onChanged: (value) {
              setState(() => _selectedRole = value!);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.security),
              labelText: "Select Role",
            ),
          ),
          const SizedBox(height: 40),

          // --- Sign Up Button ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentOrange,
                foregroundColor: textLight,
              ),
              child: const Text('Sign Up'),
            ),
          ),
          const SizedBox(height: 50),

          Center(
            child: TextButton(
              onPressed: () => _navigateToPage(1),
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
