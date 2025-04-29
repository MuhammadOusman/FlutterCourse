import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen(this.surahNumber, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          quran.getSurahName(surahNumber),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.green,
                width: 2,
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: quran.getVerseCount(surahNumber),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        quran.getVerse(surahNumber, index + 1, verseEndSymbol: true),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiriQuran(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        quran.getVerseTranslation(
                          surahNumber,
                          index + 1,
                          translation: quran.Translation.urdu,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: "Jameel",
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const Divider(
                        color: Colors.green,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}