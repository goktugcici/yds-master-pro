import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/seed_questions.dart';
import '../models/question.dart';
import 'local_storage_provider.dart';

class QuestionPracticeState {
  final List<Question> allQuestions;
  final List<Question>? customQuestionPool;
  final QuestionCategory? selectedCategory;
  final int currentIndex;
  final int? selectedOptionIndex;
  final bool hasSubmitted;
  final bool showExplanation;
  final Set<String> bookmarkedQuestionIds;
  final Map<String, bool> solvedQuestions; // questionId -> isCorrect
  final Set<String> mistakeQuestionIds;

  const QuestionPracticeState({
    required this.allQuestions,
    this.customQuestionPool,
    this.selectedCategory,
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.hasSubmitted = false,
    this.showExplanation = false,
    this.bookmarkedQuestionIds = const {},
    this.solvedQuestions = const {},
    this.mistakeQuestionIds = const {},
  });

  List<Question> get activeQuestions {
    if (customQuestionPool != null) return customQuestionPool!;
    if (selectedCategory == null) return allQuestions;
    return allQuestions.where((q) => q.category == selectedCategory).toList();
  }

  Question? get currentQuestion {
    final list = activeQuestions;
    if (currentIndex >= 0 && currentIndex < list.length) {
      return list[currentIndex];
    }
    return null;
  }

  bool get isCurrentCorrect {
    if (!hasSubmitted || currentQuestion == null || selectedOptionIndex == null) {
      return false;
    }
    return selectedOptionIndex == currentQuestion!.correctIndex;
  }

  QuestionPracticeState copyWith({
    List<Question>? allQuestions,
    List<Question>? customQuestionPool,
    bool clearCustomPool = false,
    QuestionCategory? selectedCategory,
    int? currentIndex,
    int? selectedOptionIndex,
    bool? hasSubmitted,
    bool? showExplanation,
    Set<String>? bookmarkedQuestionIds,
    Map<String, bool>? solvedQuestions,
    Set<String>? mistakeQuestionIds,
    bool clearSelectedOption = false,
  }) {
    return QuestionPracticeState(
      allQuestions: allQuestions ?? this.allQuestions,
      customQuestionPool: clearCustomPool
          ? null
          : (customQuestionPool ?? this.customQuestionPool),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOptionIndex: clearSelectedOption
          ? null
          : (selectedOptionIndex ?? this.selectedOptionIndex),
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      showExplanation: showExplanation ?? this.showExplanation,
      bookmarkedQuestionIds:
          bookmarkedQuestionIds ?? this.bookmarkedQuestionIds,
      solvedQuestions: solvedQuestions ?? this.solvedQuestions,
      mistakeQuestionIds: mistakeQuestionIds ?? this.mistakeQuestionIds,
    );
  }
}

class QuestionNotifier extends StateNotifier<QuestionPracticeState> {
  final Ref _ref;

  QuestionNotifier(this._ref)
      : super(QuestionPracticeState(allQuestions: defaultSeedQuestions)) {
    _loadSolved();
    loadQuestionsFromAsset();
  }

  Future<void> loadQuestionsFromAsset() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/questions.json');
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final questions = list.map((e) => Question.fromJson(e as Map<String, dynamic>)).toList();
      final combined = [
        ...defaultSeedQuestions,
        ...questions.where((q) => !defaultSeedQuestions.any((sq) => sq.id == q.id)),
      ];
      state = state.copyWith(allQuestions: combined);
    } catch (_) {
      // Fallback to default seed questions
    }
  }

  void _loadSolved() {
    final storage = _ref.read(localStorageProvider);
    final solved = storage.getSolvedQuestions();
    final mistakes = storage.getMistakeQuestionIds();
    state = state.copyWith(
      solvedQuestions: solved,
      mistakeQuestionIds: mistakes,
    );
  }

  void selectCategory(QuestionCategory? category) {
    state = state.copyWith(
      clearCustomPool: true,
      selectedCategory: category,
      currentIndex: 0,
      clearSelectedOption: true,
      hasSubmitted: false,
      showExplanation: false,
    );
  }

  void startMistakeRetest() {
    final mistakeIds = state.mistakeQuestionIds;
    final mistakeList = state.allQuestions
        .where((q) => mistakeIds.contains(q.id))
        .toList();

    state = state.copyWith(
      customQuestionPool: mistakeList,
      selectedCategory: null,
      currentIndex: 0,
      clearSelectedOption: true,
      hasSubmitted: false,
      showExplanation: false,
    );
  }

  void startCustomQuiz(List<Question> questions) {
    state = state.copyWith(
      customQuestionPool: questions,
      selectedCategory: null,
      currentIndex: 0,
      clearSelectedOption: true,
      hasSubmitted: false,
      showExplanation: false,
    );
  }

  void clearCustomPool() {
    state = state.copyWith(
      clearCustomPool: true,
      currentIndex: 0,
      clearSelectedOption: true,
      hasSubmitted: false,
      showExplanation: false,
    );
  }

  Future<void> removeMistake(String questionId) async {
    final storage = _ref.read(localStorageProvider);
    await storage.removeMistake(questionId);
    final updated = Set<String>.from(state.mistakeQuestionIds)..remove(questionId);
    state = state.copyWith(mistakeQuestionIds: updated);
  }

  void selectOption(int optionIndex) {
    if (state.hasSubmitted) return; // Locked once submitted
    state = state.copyWith(selectedOptionIndex: optionIndex);
  }

  Future<void> submitAnswer() async {
    if (state.selectedOptionIndex == null || state.hasSubmitted) return;
    final currentQ = state.currentQuestion;
    if (currentQ == null) return;

    final isCorrect = state.selectedOptionIndex == currentQ.correctIndex;
    final storage = _ref.read(localStorageProvider);
    await storage.recordQuestionAttempt(currentQ.id, isCorrect);

    final updatedSolved = Map<String, bool>.from(state.solvedQuestions);
    updatedSolved[currentQ.id] = isCorrect;

    final updatedMistakes = Set<String>.from(state.mistakeQuestionIds);
    if (!isCorrect) {
      updatedMistakes.add(currentQ.id);
    } else {
      updatedMistakes.remove(currentQ.id);
    }

    state = state.copyWith(
      hasSubmitted: true,
      showExplanation: true,
      solvedQuestions: updatedSolved,
      mistakeQuestionIds: updatedMistakes,
    );
  }

  void toggleExplanation() {
    state = state.copyWith(showExplanation: !state.showExplanation);
  }

  void nextQuestion() {
    final total = state.activeQuestions.length;
    if (state.currentIndex + 1 < total) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelectedOption: true,
        hasSubmitted: false,
        showExplanation: false,
      );
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        clearSelectedOption: true,
        hasSubmitted: false,
        showExplanation: false,
      );
    }
  }

  void toggleBookmark(String questionId) {
    final bookmarks = Set<String>.from(state.bookmarkedQuestionIds);
    if (bookmarks.contains(questionId)) {
      bookmarks.remove(questionId);
    } else {
      bookmarks.add(questionId);
    }
    state = state.copyWith(bookmarkedQuestionIds: bookmarks);
  }
}

final questionProvider =
    StateNotifierProvider<QuestionNotifier, QuestionPracticeState>((ref) {
  return QuestionNotifier(ref);
});

final questionNotifierProvider = questionProvider;
