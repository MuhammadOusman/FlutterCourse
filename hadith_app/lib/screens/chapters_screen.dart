// lib/screens/chapters_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hadith_app/constants.dart';
import 'package:hadith_app/screens/hadiths_screen.dart';

class ChaptersScreen extends StatefulWidget {
  final String bookSlug;
  final String bookName; // To display in AppBar

  const ChaptersScreen({super.key, required this.bookSlug, required this.bookName});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  late Future<List<dynamic>> _chaptersFuture;

  @override
  void initState() {
    super.initState();
    _chaptersFuture = _fetchChapters();
  }

  Future<List<dynamic>> _fetchChapters() async {
    final response = await http.get(Uri.parse(
        '$kBaseUrl/${widget.bookSlug}/chapters?apiKey=$kApiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data["chapters"] ?? [];
    } else {
      throw Exception('Failed to load chapters for ${widget.bookName}: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _chaptersFuture,
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
                          _chaptersFuture = _fetchChapters();
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
            return const Center(child: Text('No chapters found for this book.'));
          } else {
            final List<dynamic> chapters = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HadithsScreen(
                            bookSlug: chapter["bookSlug"],
                            chapterNumber: chapter["chapterNumber"].toString(), // Ensure string
                            chapterTitle: chapter["chapterArabic"] ?? chapter["chapterUrdu"] ?? 'Chapter', // For Hadiths Screen AppBar
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      radius: 25,
                      child: Text(
                        chapter["chapterNumber"]?.toString() ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    title: Text(
                      chapter["chapterArabic"] ?? "No Arabic Title",
                      textDirection: TextDirection.rtl, // For Arabic text
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      chapter["chapterUrdu"] ?? "No Urdu Title",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
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