import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_engine/models/synonym_entry.dart';
import 'dart:convert';

void main() {
  runApp(const SearchApp());
}

//----------------------------------------------------------------------
class SearchApp extends StatefulWidget {
  const SearchApp({super.key});

  @override
  State<SearchApp> createState() => _SearchAppState();
}

//----------------------------------------------------------------------
class _SearchAppState extends State<SearchApp> {
  List<SynonymEntry> synonymEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSynonymData();
  }

  Future<void> _loadSynonymData() async {
    final String data = await rootBundle.loadString(
      'assets/data/synonyms.json',
    );
    final List<dynamic> jsonResult = json.decode(data);
    final List<SynonymEntry> loadedEntries = jsonResult
        .map((entry) => SynonymEntry.fromJson(entry))
        .toList();
    setState(() {
      synonymEntries = loadedEntries;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(synonymEntries: synonymEntries, isLoading: _isLoading),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<SynonymEntry> synonymEntries;
  final bool isLoading;

  const HomePage({
    super.key,
    required this.synonymEntries,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Synonym Search Engine')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: synonymEntries.length,
              itemBuilder: (context, index) {
                final entry = synonymEntries[index];
                return ListTile(
                  title: Text(entry.word),
                  subtitle: Text(entry.synonyms.join(', ')),
                );
              },
            ),
    );
  }
}
