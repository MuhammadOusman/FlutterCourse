// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hadith_app/screens/splash_screen.dart'; // Import the new splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hadith Explorer', // Changed title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade700), // Slightly darker purple
        useMaterial3: true,
        appBarTheme: AppBarTheme( // Consistent app bar style
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}