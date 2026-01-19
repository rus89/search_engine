import 'dart:async';

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
  List<SynonymEntry> filteredEntries = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSynonymData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredEntries = synonymEntries.where((entry) {
          final wordMatch = entry.word.toLowerCase().contains(query);
          final synonymMatch = entry.synonyms.any(
            (syn) => syn.toLowerCase().contains(query),
          );
          return wordMatch || synonymMatch;
        }).toList();
      });
    });
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
      filteredEntries = loadedEntries;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        synonymEntries: filteredEntries,
        isLoading: _isLoading,
        searchController: _searchController,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<SynonymEntry> synonymEntries;
  final bool isLoading;
  final TextEditingController searchController;

  const HomePage({
    super.key,
    required this.synonymEntries,
    required this.isLoading,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Synonym Search Engine')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SearchWidget(
              synonymEntries: synonymEntries,
              searchController: searchController,
            ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final List<SynonymEntry> synonymEntries;
  final TextEditingController searchController;

  const SearchWidget({
    super.key,
    required this.synonymEntries,
    required this.searchController,
  });

  List<TextSpan> _highlightMatches(String source, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: source)];
    }
    final matches = <TextSpan>[];
    final queryLower = query.toLowerCase();
    final sourceLower = source.toLowerCase();
    int start = 0;
    int index;
    while ((index = sourceLower.indexOf(queryLower, start)) != -1) {
      if (index > start) {
        matches.add(TextSpan(text: source.substring(start, index)));
      }
      matches.add(
        TextSpan(
          text: source.substring(index, index + query.length),
          style: const TextStyle(backgroundColor: Colors.yellow),
        ),
      );
      start = index + query.length;
    }
    if (start < source.length) {
      matches.add(TextSpan(text: source.substring(start)));
    }
    return matches;
  }

  Widget _searchResultsList() {
    final query = searchController.text;
    if (query.isEmpty) {
      return const Center(child: Text('Please enter a search term.'));
    } else if (synonymEntries.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    return ListView.builder(
      itemCount: synonymEntries.length,
      itemBuilder: (context, index) {
        final entry = synonymEntries[index];
        return ListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 18),
              children: _highlightMatches(entry.word, query),
            ),
          ),
          subtitle: Wrap(
            spacing: 8.0,
            children: entry.synonyms.map((syn) {
              return Chip(
                label: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: _highlightMatches(syn, query),
                  ),
                ),
                backgroundColor: Colors.blue,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for a word or synonym',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _searchResultsList()),
      ],
    );
  }
}
