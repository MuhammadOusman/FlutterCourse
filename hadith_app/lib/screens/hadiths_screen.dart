// lib/screens/hadiths_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hadith_app/constants.dart';

class HadithsScreen extends StatefulWidget {
  final String bookSlug;
  final String chapterNumber;
  final String chapterTitle; // To display in AppBar

  const HadithsScreen({
    super.key,
    required this.bookSlug,
    required this.chapterNumber,
    required this.chapterTitle,
  });

  @override
  State<HadithsScreen> createState() => _HadithsScreenState();
}

class _HadithsScreenState extends State<HadithsScreen> {
  late Future<List<dynamic>> _hadithsFuture;

  @override
  void initState() {
    super.initState();
    _hadithsFuture = _fetchHadiths();
  }

  Future<List<dynamic>> _fetchHadiths() async {
    // Note the `kPublicBaseUrl` for the hadiths endpoint
    final response = await http.get(Uri.parse(
        '$kPublicBaseUrl/hadiths?apiKey=$kApiKey&book=${widget.bookSlug}&chapter=${widget.chapterNumber}&paginate=100000'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // The hadiths are nested under "hadiths" then "data"
      return data["hadiths"]["data"] ?? [];
    } else {
      throw Exception(
          'Failed to load hadiths for book ${widget.bookSlug}, chapter ${widget.chapterNumber}: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _hadithsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hadithsFuture = _fetchHadiths();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tap to Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Hadiths found for this chapter.'));
          } else {
            final List<dynamic> hadiths = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                final hadith = hadiths[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Hadith No: ${hadith["hadithNumber"]?.toString() ?? 'N/A'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 25, thickness: 1),
                        Text(
                          hadith["hadithArabic"] ?? "No Arabic Hadith",
                          textDirection: TextDirection.rtl, // For Arabic text
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.8, // Line height for better readability
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          hadith["hadithUrdu"] ?? "No Urdu Hadith",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}