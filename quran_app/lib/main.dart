import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Surah List',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SurahListScreen(),
    );
  }
}

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surah List'),
      ),
      body: ListView.builder(
        itemCount: quran.totalSurahCount,
        itemBuilder: (context, index) {
          final surahNumber = index + 1;
          final surahNameEnglish = quran.getSurahNameEnglish(surahNumber);
          final surahNameArabic = quran.getSurahNameArabic(surahNumber);

          return ListTile(
            leading: CircleAvatar(
              child: Text('$surahNumber'),
            ),
            title: Text(surahNameArabic),
            subtitle: Text(surahNameEnglish, style: const TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(surahNumber: surahNumber),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final surahNameArabic = quran.getSurahNameArabic(surahNumber);
    final verseCount = quran.getVerseCount(surahNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text(surahNameArabic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: verseCount,
          itemBuilder: (context, index) {
            final verseText = quran.getVerse(
              surahNumber,
              index + 1,
              verseEndSymbol: true,
            );
            final verseTranslation = quran.getVerseTranslation(
              surahNumber,
              index + 1,
            );

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    verseText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Amiri',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verseTranslation,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}