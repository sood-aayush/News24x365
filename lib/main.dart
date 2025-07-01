import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure this is imported
import 'themes/theme_provider.dart'; // Adjust path if different
import 'themes/app_themes.dart';
import 'screens/main_screen.dart'; // Assuming your main starting screen is MainScreen

void main() {
  // No need for 'async' here unless you have other await calls before runApp
  // Ensure Flutter binding is initialized, especially important for SharedPreferences in ThemeProvider
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ChangeNotifierProvider must wrap MyApp to provide ThemeProvider to its descendants
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer listens to ThemeProvider changes and rebuilds MaterialApp when themeMode changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false, // Set to false for production
          theme: AppThemes.lightTheme, // Your defined light theme
          darkTheme: AppThemes.darkTheme, // Your defined dark theme
          themeMode:
              themeProvider.themeMode, // Controlled by ThemeProvider's state
          home: MainScreen(), // Your app's main starting screen
        );
      },
    );
  }
}
