// lib/theme/app_themes.dart
import 'package:flutter/material.dart';

class AppThemes {
  // Define your primary blue color (you can adjust this hex code)
  static const Color primaryBlue = Color(0xFF2196F3); // Material Blue 500
  static const Color darkBlue = Color(
    0xFF1976D2,
  ); // Material Blue 700 (for dark mode primary)
  static const Color lightBlueAccent = Color(
    0xFFBBDEFB,
  ); // Material Blue 100 (for subtle accents)

  // --- Light Theme ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    // Using a very subtle light grey for the scaffold background to be less "dull" than pure white.
    scaffoldBackgroundColor: const Color(0xFFF5F5F5), // A very light grey
    // Define ColorScheme for more comprehensive color usage
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue, // Base color for the scheme
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: Colors.white, // Text/icons on primary color
      secondary: Colors.blueAccent, // Secondary accent color
      onSecondary: Colors.white,
      surface: Colors.white, // Card/sheet background
      onSurface: Colors.black87, // Text/icons on surface
      background: const Color(0xFFF5F5F5), // Same as scaffoldBackgroundColor
      onBackground: Colors.black87, // Text/icons on background
      error: Colors.red,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      color: primaryBlue, // Blue app bar
      foregroundColor: Colors.white, // White text/icons on app bar
      elevation: 4.0,
      titleTextStyle: TextStyle(
        color: Colors.white, // Ensure app bar title is white
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ), // Ensure app bar icons are white
    ),

    // Text Theme for various text styles throughout the app
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black87),
      displayMedium: TextStyle(color: Colors.black87),
      displaySmall: TextStyle(color: Colors.black87),
      headlineLarge: TextStyle(color: Colors.black87),
      headlineMedium: TextStyle(color: Colors.black87),
      headlineSmall: TextStyle(
        color: Colors.black87,
      ), // Used for section titles like "Breaking News"
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.black87),
      titleSmall: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black87), // Default text color
      bodyMedium: TextStyle(color: Colors.black54), // Secondary text color
      bodySmall: TextStyle(color: Colors.black45),
      labelLarge: TextStyle(color: Colors.black87),
      labelMedium: TextStyle(color: Colors.black87),
      labelSmall: TextStyle(color: Colors.black87),
    ),

    cardColor: Colors.white, // Card background (will use colorScheme.surface)
    dividerColor: Colors.grey.shade300, // Light divider color

    buttonTheme: ButtonThemeData(
      buttonColor: primaryBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white, // White background for BNB
      selectedItemColor: primaryBlue, // Blue for selected icon
      unselectedItemColor: Colors.grey, // Grey for unselected
      elevation: 8.0,
      type: BottomNavigationBarType.fixed, // Often preferred for 3+ items
    ),
  );

  // --- Dark Theme ---
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkBlue, // A slightly darker blue for dark mode primary
    scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark grey

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue, // Still base on blue for consistency
      brightness: Brightness.dark,
      primary: darkBlue,
      onPrimary: Colors.white,
      secondary: Colors.lightBlueAccent, // Brighter accent for dark mode
      onSecondary: Colors.black,
      surface: const Color(
        0xFF1E1E1E,
      ), // Slightly lighter dark grey for cards/sheets
      onSurface: Colors.white70, // Light text on dark surface
      background: const Color(0xFF121212),
      onBackground: Colors.white70,
      error: Colors.redAccent,
      onError: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      color: darkBlue, // Dark blue app bar
      foregroundColor: Colors.white, // White text/icons on app bar
      elevation: 4.0,
      titleTextStyle: TextStyle(
        color: Colors.white, // Ensure app bar title is white
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ), // Ensure app bar icons are white
    ),

    // Text Theme for various text styles throughout the app
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white70),
      displayMedium: TextStyle(color: Colors.white70),
      displaySmall: TextStyle(color: Colors.white70),
      headlineLarge: TextStyle(color: Colors.white70),
      headlineMedium: TextStyle(color: Colors.white70),
      headlineSmall: TextStyle(
        color: Colors.white70,
      ), // Used for section titles
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white70),
      titleSmall: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white70), // Default text color
      bodyMedium: TextStyle(color: Colors.white54), // Secondary text color
      bodySmall: TextStyle(color: Colors.white54),
      labelLarge: TextStyle(color: Colors.white70),
      labelMedium: TextStyle(color: Colors.white70),
      labelSmall: TextStyle(color: Colors.white70),
    ),

    cardColor: const Color(
      0xFF1E1E1E,
    ), // Card background (will use colorScheme.surface)
    dividerColor: Colors.grey.shade700, // Dark divider color

    buttonTheme: ButtonThemeData(
      buttonColor: darkBlue,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E), // Dark background for BNB
      selectedItemColor:
          lightBlueAccent, // Light blue for selected icon in dark mode
      unselectedItemColor: Colors.grey, // Grey for unselected
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
