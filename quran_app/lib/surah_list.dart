import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'surah_detail.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Surah List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == "All" ? Colors.green : Colors.grey[800],
                  ),
                  onPressed: () {
                    setState(() {
                      filter = "All";
                    });
                  },
                  child: Text(
                    "All",
                    style: TextStyle(
                      color: filter == "All" ? Colors.white : Colors.grey[400],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == "Makkah" ? Colors.green : Colors.grey[800],
                  ),
                  onPressed: () {
                    setState(() {
                      filter = "Makkah";
                    });
                  },
                  child: Text(
                    "Makkah",
                    style: TextStyle(
                      color: filter == "Makkah" ? Colors.white : Colors.grey[400],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter == "Madinah" ? Colors.green : Colors.grey[800],
                  ),
                  onPressed: () {
                    setState(() {
                      filter = "Madinah";
                    });
                  },
                  child: Text(
                    "Madinah",
                    style: TextStyle(
                      color: filter == "Madinah" ? Colors.white : Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Surah List
          Expanded(
            child: ListView.builder(
              itemCount: quran.totalSurahCount,
              itemBuilder: (context, index) {
                final surahNumber = index + 1;
                final placeOfRevelation = quran.getPlaceOfRevelation(surahNumber);

                // Apply filter
                if (filter == "Makkah" && placeOfRevelation != "Makkah") {
                  return const SizedBox.shrink();
                }
                if (filter == "Madinah" && placeOfRevelation != "Madinah") {
                  return const SizedBox.shrink();
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(surahNumber),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 25,
                          child: Text(
                            "$surahNumber",
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quran.getSurahNameArabic(surahNumber),
                                style: GoogleFonts.amiriQuran(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                quran.getSurahNameEnglish(surahNumber),
                                style: GoogleFonts.amiriQuran(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            placeOfRevelation == "Makkah"
                                ? Image.asset(
                                    "assets/images/kaabaa.jpg",
                                    width: 40,
                                    height: 40,
                                  )
                                : Image.asset(
                                    "assets/images/Madinaa.png",
                                    width: 40,
                                    height: 40,
                                  ),
                            const SizedBox(height: 5),
                            Text(
                              "Verses: ${quran.getVerseCount(surahNumber)}",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
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