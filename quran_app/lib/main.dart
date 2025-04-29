import 'package:flutter/material.dart';
import 'package:quran_app/splash.dart';
import 'surah_list.dart';
import 'surah_audio_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class QuranTabBar extends StatelessWidget {
  const QuranTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AL-QURAN',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Icons.menu_book),
                text: "Read Quran",
              ),
              Tab(
                icon: Icon(Icons.headphones),
                text: "Listen Quran",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SurahListScreen(), // Screen for "Read Quran"
            SurahAudioListScreen(), // Screen for "Listen Quran"
          ],
        ),
      ),
    );
  }
}