import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/seed_questions.dart';
import '../models/exam.dart';
import '../models/question.dart';
import 'local_storage_provider.dart';
import 'question_provider.dart';

class ActiveExamState {
  final Exam exam;
  final int currentQuestionIndex;
  final Map<String, int> userAnswers; // questionId -> selectedIndex
  final int remainingSeconds;
  final bool isCompleted;
  final ExamResult? result;

  const ActiveExamState({
    required this.exam,
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    required this.remainingSeconds,
    this.isCompleted = false,
    this.result,
  });

  Question get currentQuestion => exam.questions[currentQuestionIndex];
  int? get currentSelectedAnswer => userAnswers[currentQuestion.id];

  ActiveExamState copyWith({
    Exam? exam,
    int? currentQuestionIndex,
    Map<String, int>? userAnswers,
    int? remainingSeconds,
    bool? isCompleted,
    ExamResult? result,
  }) {
    return ActiveExamState(
      exam: exam ?? this.exam,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      result: result ?? this.result,
    );
  }
}

class ExamNotifier extends StateNotifier<ActiveExamState?> {
  final Ref _ref;
  Timer? _timer;

  ExamNotifier(this._ref) : super(null);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Pre-configured mock exams & branch exams
  static List<Exam> getAvailableExams([List<Question>? allPool]) {
    final pool = (allPool != null && allPool.isNotEmpty) ? allPool : defaultSeedQuestions;

    List<Question> sampleQuestions(List<QuestionCategory> categories, int count) {
      final filtered = pool.where((q) => categories.contains(q.category)).toList();
      if (filtered.length >= count) {
        return filtered.take(count).toList();
      }
      return pool.take(count).toList();
    }

    return [
      Exam(
        id: 'exam_mini_1',
        title: 'YDS Hızlı Mini Deneme (20 Soru)',
        description: 'Tüm YDS soru türlerinden dengeli 20 soru. 45 dakikalık pratik simülasyonu.',
        durationMinutes: 45,
        questions: sampleQuestions(QuestionCategory.values, 20),
        isPremiumOnly: false,
      ),
      Exam(
        id: 'exam_full_1',
        title: 'YDS 2026/1 Tam Simülasyon (80 Soru)',
        description: 'ÖSYM standartlarında 80 soruluk gerçek sınav deneyimi ve 180 dakika süre yönetimi.',
        durationMinutes: 180,
        questions: sampleQuestions(QuestionCategory.values, 80),
        isPremiumOnly: true,
      ),
      Exam(
        id: 'exam_full_2',
        title: 'YDS Akademik Master Deneme (80 Soru)',
        description: 'İleri seviye akademik makale ve çeldirici soru tipleri içeren PRO denemesi.',
        durationMinutes: 180,
        questions: sampleQuestions(QuestionCategory.values, 80),
        isPremiumOnly: true,
      ),
      // Branş Denemeleri (Branch Exams)
      Exam(
        id: 'exam_branch_vocab_grammar',
        title: 'Kelime & Gramer Branş Denemesi (26 Soru)',
        description: 'YDS ilk 26 soruluk Kelime, Phrasal Verb, Preposition ve Gramer bloğu simülasyonu.',
        durationMinutes: 40,
        questions: sampleQuestions([QuestionCategory.vocabulary, QuestionCategory.grammar], 26),
        isPremiumOnly: false,
      ),
      Exam(
        id: 'exam_branch_reading',
        title: 'Okuma & Paragraf Branş Denemesi (20 Soru)',
        description: 'YDS\'nin en belirleyici 20 soruluk akademik okuma parçaları ve paragraf tamamlama bloğu.',
        durationMinutes: 45,
        questions: sampleQuestions([QuestionCategory.reading, QuestionCategory.paragraphCompletion], 20),
        isPremiumOnly: true,
      ),
      Exam(
        id: 'exam_branch_translation',
        title: 'Çeviri & Cümle Tamamlama Branş Denemesi (20 Soru)',
        description: 'Cümle tamamlama ve her iki yönde Türkçe-İngilizce çeviri strateji testi.',
        durationMinutes: 35,
        questions: sampleQuestions([
          QuestionCategory.sentenceCompletion,
          QuestionCategory.translationEnTr,
          QuestionCategory.translationTrEn,
        ], 20),
        isPremiumOnly: false,
      ),
      Exam(
        id: 'exam_branch_skills',
        title: 'Anlam Bütünlüğü & İletişim Branş Denemesi (14 Soru)',
        description: 'Karşılıklı konuşma, anlamca en yakın cümle ve akışı bozan cümleyi bulma pratik testi.',
        durationMinutes: 25,
        questions: sampleQuestions([
          QuestionCategory.dialogue,
          QuestionCategory.restatement,
          QuestionCategory.irrelevantSentence,
        ], 14),
        isPremiumOnly: true,
      ),
    ];
  }

  static Exam createCustomExam({
    required String title,
    required int questionCount,
    required int durationMinutes,
    required List<QuestionCategory> categories,
    required List<Question> pool,
    String? difficulty,
    bool isPremiumOnly = false,
  }) {
    List<Question> filtered = pool.where((q) => categories.contains(q.category)).toList();
    if (difficulty != null && difficulty != 'Tümü') {
      final diffFiltered = filtered.where((q) => q.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
      if (diffFiltered.isNotEmpty) {
        filtered = diffFiltered;
      }
    }
    filtered = List<Question>.from(filtered)..shuffle();
    final selectedQuestions = filtered.take(questionCount).toList();

    return Exam(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: '${categories.length} kategori • ${selectedQuestions.length} soru • $durationMinutes dakika özel deneme',
      durationMinutes: durationMinutes,
      questions: selectedQuestions.isNotEmpty ? selectedQuestions : pool.take(questionCount).toList(),
      isPremiumOnly: isPremiumOnly,
    );
  }

  void startExam(Exam exam) {
    _timer?.cancel();

    state = ActiveExamState(
      exam: exam,
      currentQuestionIndex: 0,
      userAnswers: {},
      remainingSeconds: exam.durationMinutes * 60,
      isCompleted: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state == null) {
        t.cancel();
        return;
      }
      if (state!.remainingSeconds <= 1) {
        t.cancel();
        finishExam();
      } else {
        state = state!.copyWith(remainingSeconds: state!.remainingSeconds - 1);
      }
    });
  }

  void selectAnswer(String questionId, int optionIndex) {
    if (state == null || state!.isCompleted) return;
    final updated = Map<String, int>.from(state!.userAnswers);
    updated[questionId] = optionIndex;
    state = state!.copyWith(userAnswers: updated);
  }

  void jumpToQuestion(int index) {
    if (state == null) return;
    if (index >= 0 && index < state!.exam.questions.length) {
      state = state!.copyWith(currentQuestionIndex: index);
    }
  }

  void nextQuestion() {
    if (state == null) return;
    jumpToQuestion(state!.currentQuestionIndex + 1);
  }

  void previousQuestion() {
    if (state == null) return;
    jumpToQuestion(state!.currentQuestionIndex - 1);
  }

  Future<ExamResult?> finishExam() async {
    _timer?.cancel();
    if (state == null) return null;

    final exam = state!.exam;
    final answers = state!.userAnswers;

    int correct = 0;
    int wrong = 0;
    int empty = 0;

    for (final q in exam.questions) {
      final selected = answers[q.id];
      if (selected == null) {
        empty++;
      } else if (selected == q.correctIndex) {
        correct++;
      } else {
        wrong++;
      }
    }

    final total = exam.questions.length;
    final score = total > 0 ? (correct / total) * 100.0 : 0.0;
    final grade = ExamResult.calculateGrade(score);
    final spentSeconds = (exam.durationMinutes * 60) - state!.remainingSeconds;

    final result = ExamResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      examId: exam.id,
      examTitle: exam.title,
      totalQuestions: total,
      correctCount: correct,
      wrongCount: wrong,
      emptyCount: empty,
      score: double.parse(score.toStringAsFixed(1)),
      letterGrade: grade,
      userAnswers: answers,
      completedAt: DateTime.now(),
      timeSpentSeconds: spentSeconds,
    );

    final storage = _ref.read(localStorageProvider);
    await storage.saveExamResult(result);

    state = state!.copyWith(
      isCompleted: true,
      result: result,
    );

    return result;
  }
}

final examStateProvider =
    StateNotifierProvider<ExamNotifier, ActiveExamState?>((ref) {
  return ExamNotifier(ref);
});

final examHistoryProvider = Provider<List<ExamResult>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return storage.getExamResults();
});

final availableExamsProvider = Provider<List<Exam>>((ref) {
  final qState = ref.watch(questionNotifierProvider);
  return ExamNotifier.getAvailableExams(qState.allQuestions);
});
