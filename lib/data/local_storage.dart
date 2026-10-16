import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam.dart';
import '../models/subscription_plan.dart';

class LocalStorage {
  static const String _keySubscription = 'yds_user_subscription';
  static const String _keyLearnedWords = 'yds_learned_words';
  static const String _keyFavoriteWords = 'yds_favorite_words';
  static const String _keyWordSrs = 'yds_word_srs_levels';
  static const String _keySolvedQuestions = 'yds_solved_questions';
  static const String _keyExamResults = 'yds_exam_results';
  static const String _keyStreak = 'yds_streak_count';
  static const String _keyLastActiveDay = 'yds_last_active_day';
  static const String _keyDarkMode = 'yds_dark_mode';
  static const String _keyTargetScore = 'yds_target_score';
  static const String _keyTargetExamDate = 'yds_target_exam_date';
  static const String _keyMistakeQuestions = 'yds_mistake_questions';

  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  static Future<LocalStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage(prefs);
  }

  // --- SUBSCRIPTION ---
  UserSubscription getSubscription() {
    final data = _prefs.getString(_keySubscription);
    if (data == null) return const UserSubscription();
    try {
      return UserSubscription.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      return const UserSubscription();
    }
  }

  Future<void> saveSubscription(UserSubscription subscription) async {
    await _prefs.setString(_keySubscription, jsonEncode(subscription.toJson()));
  }

  // --- WORDS & SRS ---
  Set<String> getLearnedWordIds() {
    final list = _prefs.getStringList(_keyLearnedWords) ?? [];
    return list.toSet();
  }

  Future<void> setWordLearned(String wordId, bool isLearned) async {
    final learned = getLearnedWordIds();
    if (isLearned) {
      learned.add(wordId);
    } else {
      learned.remove(wordId);
    }
    await _prefs.setStringList(_keyLearnedWords, learned.toList());
  }

  Set<String> getFavoriteWordIds() {
    final list = _prefs.getStringList(_keyFavoriteWords) ?? [];
    return list.toSet();
  }

  Future<void> toggleWordFavorite(String wordId) async {
    final favs = getFavoriteWordIds();
    if (favs.contains(wordId)) {
      favs.remove(wordId);
    } else {
      favs.add(wordId);
    }
    await _prefs.setStringList(_keyFavoriteWords, favs.toList());
  }

  Map<String, int> getWordSrsLevels() {
    final raw = _prefs.getString(_keyWordSrs);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  Future<void> updateWordSrs(String wordId, int level) async {
    final map = getWordSrsLevels();
    map[wordId] = level;
    await _prefs.setString(_keyWordSrs, jsonEncode(map));
  }

  // --- SOLVED QUESTIONS ---
  // Map of questionId -> isCorrect (bool)
  Map<String, bool> getSolvedQuestions() {
    final raw = _prefs.getString(_keySolvedQuestions);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as bool));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveQuestionResult(String questionId, bool isCorrect) async {
    final map = getSolvedQuestions();
    map[questionId] = isCorrect;
    await _prefs.setString(_keySolvedQuestions, jsonEncode(map));
  }

  // --- EXAM RESULTS ---
  List<ExamResult> getExamResults() {
    final list = _prefs.getStringList(_keyExamResults) ?? [];
    return list.map((item) {
      try {
        return ExamResult.fromJson(jsonDecode(item) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<ExamResult>().toList();
  }

  Future<void> saveExamResult(ExamResult result) async {
    final current = _prefs.getStringList(_keyExamResults) ?? [];
    current.insert(0, jsonEncode(result.toJson())); // latest first
    await _prefs.setStringList(_keyExamResults, current);
  }

  // --- STREAK & STATS ---
  int getStreak() => _prefs.getInt(_keyStreak) ?? 1;

  Future<void> checkAndUpdateStreak() async {
    final now = DateTime.now();
    final today = "${now.year}-${now.month}-${now.day}";
    final lastDay = _prefs.getString(_keyLastActiveDay);

    if (lastDay == null) {
      await _prefs.setString(_keyLastActiveDay, today);
      await _prefs.setInt(_keyStreak, 1);
      return;
    }

    if (lastDay == today) {
      return; // Already counted today
    }

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterday.year}-${yesterday.month}-${yesterday.day}";

    if (lastDay == yesterdayStr) {
      // Continued streak
      final streak = getStreak() + 1;
      await _prefs.setInt(_keyStreak, streak);
    } else {
      // Broken streak, restart
      await _prefs.setInt(_keyStreak, 1);
    }
    await _prefs.setString(_keyLastActiveDay, today);
  }

  // --- DARK MODE ---
  bool isDarkMode() => _prefs.getBool(_keyDarkMode) ?? false;
  Future<void> setDarkMode(bool isDark) async => _prefs.setBool(_keyDarkMode, isDark);

  // --- TARGET SCORE ---
  int getTargetScore() => _prefs.getInt(_keyTargetScore) ?? 70;
  Future<void> setTargetScore(int score) async => _prefs.setInt(_keyTargetScore, score);

  // --- TARGET EXAM DATE ---
  DateTime getTargetExamDate() {
    final str = _prefs.getString(_keyTargetExamDate);
    if (str == null) {
      // Default: Next YDS 45 days ahead
      return DateTime.now().add(const Duration(days: 45));
    }
    return DateTime.tryParse(str) ?? DateTime.now().add(const Duration(days: 45));
  }

  Future<void> setTargetExamDate(DateTime date) async {
    await _prefs.setString(_keyTargetExamDate, date.toIso8601String());
  }

  // --- MISTAKE NOTEBOOK ---
  Set<String> getMistakeQuestionIds() {
    final list = _prefs.getStringList(_keyMistakeQuestions) ?? [];
    return list.toSet();
  }

  Future<void> recordQuestionAttempt(String questionId, bool isCorrect) async {
    await saveQuestionResult(questionId, isCorrect);
    final mistakes = getMistakeQuestionIds();
    if (!isCorrect) {
      mistakes.add(questionId);
    } else {
      mistakes.remove(questionId);
    }
    await _prefs.setStringList(_keyMistakeQuestions, mistakes.toList());
  }

  Future<void> removeMistake(String questionId) async {
    final mistakes = getMistakeQuestionIds();
    mistakes.remove(questionId);
    await _prefs.setStringList(_keyMistakeQuestions, mistakes.toList());
  }
}
