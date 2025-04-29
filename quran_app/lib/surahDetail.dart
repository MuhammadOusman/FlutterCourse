import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen(this.surahNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quran.getSurahName(surahNumber))),
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
