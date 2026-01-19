# Synonym Search Engine

A Flutter learning project demonstrating efficient search, filtering, and real-time text matching with a clean, responsive UI.

## Overview

This is a foundational project for building a Serbian thesaurus/synonym application. It implements a high-performance search engine that loads synonym data from static assets and provides instant, debounced search results with text highlighting.

**Purpose:** Learn core Flutter concepts while building a practical, production-adjacent application.

## Features

- **Live Search** — Real-time filtering as you type
- **Debounced Input** — 300ms debounce to prevent excessive rebuilds and improve performance
- **Text Highlighting** — Matched search terms are highlighted in yellow for instant visual feedback
- **Efficient List Rendering** — Uses `ListView.builder` for memory-efficient rendering of large datasets
- **Asset Loading** — Loads synonym data from JSON bundled with the app
- **Empty State Handling** — User-friendly messages for empty searches and no results
- **Smart Filtering** — Searches both word names and their synonyms in a single query

## Technology Stack

- **Language:** Dart 3.10.7+
- **Framework:** Flutter
- **State Management:** StatefulWidget (no external dependencies)
- **Data Format:** JSON (static assets)
- **Architecture:** Component-based (SearchApp → HomePage → SearchWidget)

## Getting Started

### Prerequisites

- Flutter SDK: `^3.10.7`
- Dart: `^3.10.7`
- A device or emulator (iOS/Android/Web)

### Installation

1. **Clone the repository:**

   ```bash
   cd search_engine
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

Project Structure

        lib/
    ├── [main.dart](http://_vscodecontentref_/0)              # App entry point, state management, UI widgets
    ├── models/
    │   └── synonym_entry.dart # Data model for synonym entries
    assets/
    └── data/
        └── synonyms.json      # Static synonym database (25+ English words)

Key Files

- [main.dart](lib/main.dart) — Contains `SearchApp` (state), `HomePage`, and `SearchWidget` (UI)
- [synonym_entry.dart](lib/models/synonym_entry.dart) — Model class with JSON deserialization via factory method
- [synonyms.json](assets/data/synonyms.json) — Curated dataset with 25 words and 4-5 synonyms each

## How It Works

1. **Data Loading**: On app startup, `_loadSynonymData()` loads JSON from assets and parses it into `SynonymEntry` objects.
2. **Search Input**: `TextField` listens for changes via `TextEditingController`.
3. **Debounced Filtering**: User input triggers a 300ms timer. If the user pauses, the list is filtered; rapid typing won't trigger multiple filters.
4. Real-time Updates: `setState()` rebuilds only the filtered results.
5. **Text Highlighting**: `RichText` with `TextSpan` highlights matching query terms in yellow.

## Learning Outcomes

This project demonstrates:

✅ **Async data loading** — rootBundle, Future, async/await

✅ **State management** — StatefulWidget, setState(), lifecycle management

✅ **Text rendering** — TextField, RichText, TextSpan for advanced text styling

✅ **List optimization** — ListView.builder, efficient filtering with .where()

✅ **Debouncing** — Timer-based input debouncing to optimize performance

✅ **Model classes** — Type-safe data with factory constructors for JSON parsing

✅ **Component architecture** — Separation of concerns across widget hierarchy

## Performance Notes

- No jank on search: Debouncing prevents excessive rebuilds
- Memory efficient: ListView.builder only renders visible items
- Fast filtering: O(n) search over 25 words is instant; scales well to ~500 words

## Author

Built as a learning project to master Flutter fundamentals before scaling to a production Serbian thesaurus app.
