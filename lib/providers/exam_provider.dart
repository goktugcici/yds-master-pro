import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/seed_questions.dart';
import '../models/exam.dart';
import '../models/question.dart';
import 'local_storage_provider.dart';

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

  // Pre-configured mock exams
  static List<Exam> getAvailableExams() {
    return [
      Exam(
        id: 'exam_mini_1',
        title: 'YDS Hızlı Mini Deneme (20 Soru)',
        description: 'Tüm YDS soru türlerinden dengeli 20 soru. 45 dakikalık pratik simülasyonu.',
        durationMinutes: 45,
        questions: defaultSeedQuestions, // Uses the available questions pool
        isPremiumOnly: false,
      ),
      Exam(
        id: 'exam_full_1',
        title: 'YDS 2026/1 Tam Simülasyon (80 Soru)',
        description: 'ÖSYM standartlarında 80 soruluk gerçek sınav deneyimi ve 180 dakika süre yönetimi.',
        durationMinutes: 180,
        questions: defaultSeedQuestions,
        isPremiumOnly: true,
      ),
      Exam(
        id: 'exam_full_2',
        title: 'YDS Akademik Master Deneme (80 Soru)',
        description: 'İleri seviye akademik makale ve çeldirici soru tipleri içeren PRO denemesi.',
        durationMinutes: 180,
        questions: defaultSeedQuestions,
        isPremiumOnly: true,
      ),
    ];
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
