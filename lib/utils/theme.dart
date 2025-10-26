import 'package:flutter/material.dart';

// Disaster Theme Colors
const Color primaryDarkBlue = Color(0xFF1A237E); // Deep Indigo/Navy for authority
const Color accentOrange = Color(0xFFE65100);  // Deep Orange for primary action/alert
const Color warningRed = Color(0xFFD32F2F); // Red for critical warnings
const Color secondaryLightBlue = Color(0xFFBBDEFB); // Light Blue for light surfaces
const Color backgroundWhite = Colors.white;
const Color textDark = Colors.black87;
const Color textLight = Colors.white;
const Color greyText = Colors.grey;


class AppTheme {
  // Original lightTheme is replaced by the disaster theme
  static final ThemeData disasterTheme = ThemeData(
    // We keep the green primary color for compatibility or change it to blue
    primaryColor: primaryDarkBlue,
    hintColor: accentOrange,
    scaffoldBackgroundColor: backgroundWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryDarkBlue,
      primary: primaryDarkBlue,
      secondary: accentOrange,
      surface: backgroundWhite,
      error: warningRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryDarkBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textLight),
    ),
    textTheme: const TextTheme(
      // Updated text themes to use dark text color by default
      bodyMedium: TextStyle(fontSize: 16, color: textDark),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textDark),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
      // Adding a large style for headers on the auth screen
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: secondaryLightBlue.withOpacity(0.3), // Light background for inputs
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryDarkBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      hintStyle: TextStyle(color: greyText.withOpacity(0.7)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textLight, // Default text color on buttons is light
        backgroundColor: primaryDarkBlue, // Default button color is dark blue
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
    // Adding Outlined Button Theme for secondary actions like 'Sign Up'
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textLight, // Text color is light on the landing page
        side: const BorderSide(color: textLight),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}