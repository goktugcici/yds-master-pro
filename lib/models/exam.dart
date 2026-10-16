import 'question.dart';

class Exam {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final List<Question> questions;
  final bool isPremiumOnly;

  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.questions,
    this.isPremiumOnly = false,
  });

  int get questionCount => questions.length;
}

class ExamResult {
  final String id;
  final String examId;
  final String examTitle;
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int emptyCount;
  final double score; // 0.0 - 100.0
  final String letterGrade; // A, B, C, D, E, F
  final Map<String, int> userAnswers; // questionId -> selectedIndex
  final DateTime completedAt;
  final int timeSpentSeconds;

  const ExamResult({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.emptyCount,
    required this.score,
    required this.letterGrade,
    required this.userAnswers,
    required this.completedAt,
    required this.timeSpentSeconds,
  });

  static String calculateGrade(double score) {
    if (score >= 90) return 'A (90-100)';
    if (score >= 80) return 'B (80-89)';
    if (score >= 70) return 'C (70-79)';
    if (score >= 60) return 'D (60-69)';
    if (score >= 50) return 'E (50-59)';
    return 'F (Başarısız)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'examTitle': examTitle,
      'totalQuestions': totalQuestions,
      'correctCount': correctCount,
      'wrongCount': wrongCount,
      'emptyCount': emptyCount,
      'score': score,
      'letterGrade': letterGrade,
      'userAnswers': userAnswers,
      'completedAt': completedAt.toIso8601String(),
      'timeSpentSeconds': timeSpentSeconds,
    };
  }

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'] as String,
      examId: json['examId'] as String,
      examTitle: json['examTitle'] as String? ?? 'YDS Denemesi',
      totalQuestions: json['totalQuestions'] as int,
      correctCount: json['correctCount'] as int,
      wrongCount: json['wrongCount'] as int,
      emptyCount: json['emptyCount'] as int,
      score: (json['score'] as num).toDouble(),
      letterGrade: json['letterGrade'] as String,
      userAnswers: (json['userAnswers'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as int),
      ),
      completedAt: DateTime.parse(json['completedAt'] as String),
      timeSpentSeconds: json['timeSpentSeconds'] as int,
    );
  }
}
