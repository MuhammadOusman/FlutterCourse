// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:hadith_app/screens/books_screen.dart'; // Import your main content screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Simulate some loading time
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to the main screen and replace the splash screen
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BooksScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // Use theme primary color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book, // A nice icon
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Hadith Explorer',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Explore the Wisdom of Hadith',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // White loading indicator
            ),
          ],
        ),
      ),
    );
  }
}