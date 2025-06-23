// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:todo_app/screens/todo_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.white,
        size: 100,
      ),
      backgroundColor: Colors.teal,
      nextScreen: const TodoScreen(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 1500, // 1.5 seconds
    );
  }
}