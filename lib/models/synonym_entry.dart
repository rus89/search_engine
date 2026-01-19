class SynonymEntry {
  final String word;
  final List<String> synonyms;

  SynonymEntry({required this.word, required this.synonyms});

  factory SynonymEntry.fromJson(Map<String, dynamic> json) {
    return SynonymEntry(
      word: json['word'],
      synonyms: List<String>.from(json['synonyms']),
    );
  }
}
