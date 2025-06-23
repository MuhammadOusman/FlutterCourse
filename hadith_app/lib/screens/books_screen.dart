// lib/screens/books_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hadith_app/constants.dart';
import 'package:hadith_app/screens/chapters_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late Future<List<dynamic>> _booksFuture; // Use Future for async data

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooks(); // Start fetching data immediately
  }

  Future<List<dynamic>> _fetchBooks() async {
    final response = await http.get(Uri.parse('$kBaseUrl/books?apiKey=$kApiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data["books"] ?? []; // Return the list of books, or an empty list if null
    } else {
      throw Exception('Failed to load books: ${response.statusCode}'); // Throw an error for FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith Books'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
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
                          _booksFuture = _fetchBooks(); // Retry fetching data
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
            return const Center(child: Text('No Hadith books found.')); // Handle empty data
          } else {
            // Data loaded successfully
            final List<dynamic> books = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
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
                          builder: (context) => ChaptersScreen(
                            bookSlug: book["bookSlug"],
                            bookName: book["bookName"] ?? "Unknown Book", // Pass book name for AppBar
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      radius: 25,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    title: Text(
                      book["bookName"] ?? "No Name",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      book["writerName"] ?? "Unknown Writer",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Chapters: ${book["chapters_count"]?.toString() ?? 'N/A'}",
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                        ),
                        Text(
                          "Hadiths: ${book["hadiths_count"]?.toString() ?? 'N/A'}",
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
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