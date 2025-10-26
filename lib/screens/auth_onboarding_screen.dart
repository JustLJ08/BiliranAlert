import 'package:flutter/material.dart';
import 'package:biliran_alert/screens/home_dashboard.dart';
import 'package:biliran_alert/utils/theme.dart';

class AuthOnboardingScreen extends StatefulWidget {
  const AuthOnboardingScreen({super.key});

  @override
  State<AuthOnboardingScreen> createState() => _AuthOnboardingScreenState();
}

class _AuthOnboardingScreenState extends State<AuthOnboardingScreen> {
  final PageController _pageController = PageController();

  void _navigateToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
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
            decoration: InputDecoration(
              hintText: 'Email Address',
              prefixIcon:
                  Icon(Icons.email, color: primaryDarkBlue.withOpacity(0.7)),
            ),
            style: const TextStyle(color: textDark),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon:
                  Icon(Icons.lock, color: primaryDarkBlue.withOpacity(0.7)),
              suffixIcon: Icon(Icons.visibility_off,
                  color: primaryDarkBlue.withOpacity(0.7)),
            ),
            style: const TextStyle(color: textDark),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                      color: textLight.withOpacity(0.7), fontSize: 16),
                  children: const [
                    TextSpan(
                      text: 'Sign Up Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
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
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: textLight),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            decoration: InputDecoration(
              hintText: 'Email Address',
              prefixIcon:
                  Icon(Icons.email, color: primaryDarkBlue.withOpacity(0.7)),
            ),
            style: const TextStyle(color: textDark),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon:
                  Icon(Icons.lock, color: primaryDarkBlue.withOpacity(0.7)),
            ),
            style: const TextStyle(color: textDark),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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
              child: RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                      color: textLight.withOpacity(0.7), fontSize: 16),
                  children: const [
                    TextSpan(
                      text: 'Login Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
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
    super.dispose();
  }
}
