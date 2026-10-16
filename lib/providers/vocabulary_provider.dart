import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/seed_words.dart';
import '../models/word.dart';
import 'local_storage_provider.dart';

class VocabularyState {
  final List<Word> allWords;
  final String selectedCategory; // 'all', 'verb', 'noun', 'adj', 'phrasal_verb', 'collocation'
  final String selectedFilter; // 'all', 'learned', 'review', 'favorites'
  final String searchQuery;
  final int currentCardIndex;

  const VocabularyState({
    required this.allWords,
    this.selectedCategory = 'all',
    this.selectedFilter = 'all',
    this.searchQuery = '',
    this.currentCardIndex = 0,
  });

  List<Word> get filteredWords {
    return allWords.where((w) {
      // Search query
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchesEng = w.english.toLowerCase().contains(q);
        final matchesTr = w.turkish.toLowerCase().contains(q);
        if (!matchesEng && !matchesTr) return false;
      }

      // Category filter
      if (selectedCategory != 'all' && w.partOfSpeech != selectedCategory) {
        return false;
      }

      // Status filter
      if (selectedFilter == 'learned' && !w.isLearned) return false;
      if (selectedFilter == 'review' && (w.isLearned || w.srsLevel == 0)) return false;
      if (selectedFilter == 'favorites' && !w.isFavorite) return false;

      return true;
    }).toList();
  }

  int get learnedCount => allWords.where((w) => w.isLearned).length;
  int get favoriteCount => allWords.where((w) => w.isFavorite).length;
  int get inProgressCount => allWords.where((w) => !w.isLearned && w.srsLevel > 0).length;

  VocabularyState copyWith({
    List<Word>? allWords,
    String? selectedCategory,
    String? selectedFilter,
    String? searchQuery,
    int? currentCardIndex,
  }) {
    return VocabularyState(
      allWords: allWords ?? this.allWords,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
    );
  }
}

class VocabularyNotifier extends StateNotifier<VocabularyState> {
  final Ref _ref;

  VocabularyNotifier(this._ref)
      : super(VocabularyState(allWords: defaultSeedWords)) {
    _loadSavedState();
    loadWordsFromAsset();
  }

  Future<void> loadWordsFromAsset() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/words.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final words = list.map((e) => Word.fromJson(e as Map<String, dynamic>)).toList();
      final storage = _ref.read(localStorageProvider);
      final learned = storage.getLearnedWordIds();
      final favs = storage.getFavoriteWordIds();
      final srs = storage.getWordSrsLevels();

      final updatedWords = words.map((w) {
        return w.copyWith(
          isLearned: learned.contains(w.id),
          isFavorite: favs.contains(w.id),
          srsLevel: srs[w.id] ?? 0,
        );
      }).toList();

      state = state.copyWith(allWords: updatedWords);
    } catch (_) {
      // Keep default seed words if assets not loaded or in mock test environment
    }
  }

  void _loadSavedState() {
    final storage = _ref.read(localStorageProvider);
    final learned = storage.getLearnedWordIds();
    final favs = storage.getFavoriteWordIds();
    final srs = storage.getWordSrsLevels();

    final updatedWords = state.allWords.map((w) {
      return w.copyWith(
        isLearned: learned.contains(w.id),
        isFavorite: favs.contains(w.id),
        srsLevel: srs[w.id] ?? 0,
      );
    }).toList();

    state = state.copyWith(allWords: updatedWords);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category, currentCardIndex: 0);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter, currentCardIndex: 0);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentCardIndex: 0);
  }

  void nextCard() {
    final len = state.filteredWords.length;
    if (len == 0) return;
    state = state.copyWith(
      currentCardIndex: (state.currentCardIndex + 1) % len,
    );
  }

  void previousCard() {
    final len = state.filteredWords.length;
    if (len == 0) return;
    state = state.copyWith(
      currentCardIndex: (state.currentCardIndex - 1 + len) % len,
    );
  }

  Future<void> markWordLearned(String wordId, bool isLearned) async {
    final storage = _ref.read(localStorageProvider);
    await storage.setWordLearned(wordId, isLearned);

    final updated = state.allWords.map((w) {
      if (w.id == wordId) {
        final newSrs = isLearned ? 5 : 1;
        storage.updateWordSrs(wordId, newSrs);
        return w.copyWith(isLearned: isLearned, srsLevel: newSrs);
      }
      return w;
    }).toList();

    state = state.copyWith(allWords: updated);
  }

  Future<void> toggleFavorite(String wordId) async {
    final storage = _ref.read(localStorageProvider);
    await storage.toggleWordFavorite(wordId);

    final updated = state.allWords.map((w) {
      if (w.id == wordId) {
        return w.copyWith(isFavorite: !w.isFavorite);
      }
      return w;
    }).toList();

    state = state.copyWith(allWords: updated);
  }

  // Spaced Repetition (SRS): User clicked "Biliyorum" (know it)
  Future<void> answerKnown(String wordId) async {
    final storage = _ref.read(localStorageProvider);
    final word = state.allWords.firstWhere((w) => w.id == wordId);
    final newLevel = (word.srsLevel + 1).clamp(0, 5);
    final isLearned = newLevel >= 4;

    await storage.updateWordSrs(wordId, newLevel);
    await storage.setWordLearned(wordId, isLearned);

    final updated = state.allWords.map((w) {
      if (w.id == wordId) {
        return w.copyWith(srsLevel: newLevel, isLearned: isLearned);
      }
      return w;
    }).toList();

    state = state.copyWith(allWords: updated);
    nextCard();
  }

  // Spaced Repetition (SRS): User clicked "Tekrar Et" (need review)
  Future<void> answerUnknown(String wordId) async {
    final storage = _ref.read(localStorageProvider);
    await storage.updateWordSrs(wordId, 1);
    await storage.setWordLearned(wordId, false);

    final updated = state.allWords.map((w) {
      if (w.id == wordId) {
        return w.copyWith(srsLevel: 1, isLearned: false);
      }
      return w;
    }).toList();

    state = state.copyWith(allWords: updated);
    nextCard();
  }
}

final vocabularyProvider =
    StateNotifierProvider<VocabularyNotifier, VocabularyState>((ref) {
  return VocabularyNotifier(ref);
});
