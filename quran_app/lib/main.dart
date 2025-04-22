import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';

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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SurahListScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/Quraan.png"), // Splash screen image
      ),
    );
  }
}

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  String filter = "All"; // Default filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah List'),
      ),
      body: Column(
        children: [
          // Buttons for filtering
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = "All";
                  });
                },
                child: const Text("All"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = "Makkah";
                  });
                },
                child: const Text("Makkah"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = "Madinah";
                  });
                },
                child: const Text("Madinah"),
              ),
            ],
          ),
          // Surah List
          Expanded(
            child: ListView.builder(
              itemCount: quran.totalSurahCount,
              itemBuilder: (context, index) {
                final surahNumber = index + 1;
                final placeOfRevelation =
                    quran.getPlaceOfRevelation(surahNumber);

                // Apply filter
                if (filter == "Makkah" && placeOfRevelation != "Makkah") {
                  return const SizedBox.shrink();
                }
                if (filter == "Madinah" && placeOfRevelation != "Madinah") {
                  return const SizedBox.shrink();
                }

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(surahNumber),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    child: Text("$surahNumber"),
                  ),
                  title: Text(
                    quran.getSurahNameArabic(surahNumber),
                    style: GoogleFonts.amiriQuran(),
                  ),
                  subtitle: Text(
                    quran.getSurahNameEnglish(surahNumber),
                    style: GoogleFonts.amiriQuran(),
                  ),
                  trailing: Column(
                    children: [
                      placeOfRevelation == "Makkah"
                          ? Image.asset(
                              "assets/images/kaabaa.jpg",
                              width: 30,
                              height: 30,
                            )
                          : Image.asset(
                              "assets/images/Madinaa.png",
                              width: 30,
                              height: 30,
                            ),
                      Text("Verses: ${quran.getVerseCount(surahNumber)}"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen(this.surahNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quran.getSurahName(surahNumber)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(surahNumber),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(surahNumber, index + 1, verseEndSymbol: true),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiriQuran(),
                ),
                subtitle: Text(
                  quran.getVerseTranslation(
                    surahNumber,
                    index + 1,
                    translation: quran.Translation.urdu,
                  ),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontFamily: "Jameel"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}