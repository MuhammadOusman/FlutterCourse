import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'surahdetail.dart';

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
      appBar: AppBar(title: const Text('Surah List')),
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
                final placeOfRevelation = quran.getPlaceOfRevelation(
                  surahNumber,
                );

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
                  leading: CircleAvatar(child: Text("$surahNumber")),
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
