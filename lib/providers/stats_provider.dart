import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import 'local_storage_provider.dart';
import 'question_provider.dart';
import 'vocabulary_provider.dart';

class OverallStats {
  final int streakDays;
  final int totalSolved;
  final int totalCorrect;
  final int totalWrong;
  final double accuracyPercentage;
  final int wordsLearned;
  final int wordsTotal;
  final Map<QuestionCategory, double> categoryAccuracy;
  final Map<QuestionCategory, int> categoryTotalSolved;
  final QuestionCategory? weakestCategory;
  final double estimatedScore;
  final String letterGrade;

  const OverallStats({
    required this.streakDays,
    required this.totalSolved,
    required this.totalCorrect,
    required this.totalWrong,
    required this.accuracyPercentage,
    required this.wordsLearned,
    required this.wordsTotal,
    required this.categoryAccuracy,
    this.categoryTotalSolved = const {},
    this.weakestCategory,
    this.estimatedScore = 0.0,
    this.letterGrade = 'N/A',
  });
}

final statsProvider = Provider<OverallStats>((ref) {
  final storage = ref.watch(localStorageProvider);
  final vocabState = ref.watch(vocabularyProvider);
  final questionState = ref.watch(questionNotifierProvider);

  final streak = storage.getStreak();
  final solvedMap = storage.getSolvedQuestions();

  final totalSolved = solvedMap.length;
  final totalCorrect = solvedMap.values.where((c) => c).length;
  final totalWrong = totalSolved - totalCorrect;
  final accuracy = totalSolved > 0 ? (totalCorrect / totalSolved) * 100.0 : 0.0;

  // Calculate per category accuracy across all questions
  final Map<QuestionCategory, int> categoryTotal = {};
  final Map<QuestionCategory, int> categoryCorrect = {};

  for (final q in questionState.allQuestions) {
    if (solvedMap.containsKey(q.id)) {
      categoryTotal[q.category] = (categoryTotal[q.category] ?? 0) + 1;
      if (solvedMap[q.id] == true) {
        categoryCorrect[q.category] = (categoryCorrect[q.category] ?? 0) + 1;
      }
    }
  }

  final Map<QuestionCategory, double> categoryAccuracy = {};
  QuestionCategory? weakestCat;
  double lowestAcc = 101.0;

  for (final cat in QuestionCategory.values) {
    final total = categoryTotal[cat] ?? 0;
    final correct = categoryCorrect[cat] ?? 0;
    final catAcc = total > 0 ? (correct / total) * 100.0 : 0.0;
    categoryAccuracy[cat] = catAcc;

    if (total > 0 && catAcc < lowestAcc) {
      lowestAcc = catAcc;
      weakestCat = cat;
    }
  }

  // If no category has been solved yet, default weakest suggestion
  weakestCat ??= QuestionCategory.grammar;

  final estimatedScore = totalSolved >= 5 ? double.parse(accuracy.toStringAsFixed(1)) : 0.0;
  String grade;
  if (estimatedScore >= 90) {
    grade = 'A (90-100)';
  } else if (estimatedScore >= 80) {
    grade = 'B (80-89)';
  } else if (estimatedScore >= 70) {
    grade = 'C (70-79)';
  } else if (estimatedScore >= 60) {
    grade = 'D (60-69)';
  } else if (estimatedScore >= 50) {
    grade = 'E (50-59)';
  } else if (totalSolved >= 5) {
    grade = 'F (<50)';
  } else {
    grade = 'Henüz Veri Yok';
  }

  return OverallStats(
    streakDays: streak,
    totalSolved: totalSolved,
    totalCorrect: totalCorrect,
    totalWrong: totalWrong,
    accuracyPercentage: accuracy,
    wordsLearned: vocabState.learnedCount,
    wordsTotal: vocabState.allWords.length,
    categoryAccuracy: categoryAccuracy,
    categoryTotalSolved: categoryTotal,
    weakestCategory: weakestCat,
    estimatedScore: estimatedScore,
    letterGrade: grade,
  );
});

class TargetScoreNotifier extends StateNotifier<int> {
  final Ref _ref;
  TargetScoreNotifier(this._ref) : super(70) {
    state = _ref.read(localStorageProvider).getTargetScore();
  }

  Future<void> setScore(int score) async {
    state = score;
    await _ref.read(localStorageProvider).setTargetScore(score);
  }
}

final targetScoreProvider = StateNotifierProvider<TargetScoreNotifier, int>((ref) {
  return TargetScoreNotifier(ref);
});

class TargetExamDateNotifier extends StateNotifier<DateTime> {
  final Ref _ref;
  TargetExamDateNotifier(this._ref)
      : super(DateTime.now().add(const Duration(days: 45))) {
    state = _ref.read(localStorageProvider).getTargetExamDate();
  }

  Future<void> setExamDate(DateTime date) async {
    state = date;
    await _ref.read(localStorageProvider).setTargetExamDate(date);
  }
}

final targetExamDateProvider =
    StateNotifierProvider<TargetExamDateNotifier, DateTime>((ref) {
  return TargetExamDateNotifier(ref);
});

