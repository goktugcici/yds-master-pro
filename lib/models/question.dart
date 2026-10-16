import 'package:flutter/material.dart';

enum QuestionCategory {
  vocabulary,
  grammar,
  sentenceCompletion,
  translationEnTr,
  translationTrEn,
  reading,
  dialogue,
  restatement,
  paragraphCompletion,
  irrelevantSentence,
}

extension QuestionCategoryExtension on QuestionCategory {
  String get title {
    switch (this) {
      case QuestionCategory.vocabulary:
        return 'Kelime Bilgisi';
      case QuestionCategory.grammar:
        return 'Gramer & Dilbilgisi';
      case QuestionCategory.sentenceCompletion:
        return 'Cümle Tamamlama';
      case QuestionCategory.translationEnTr:
        return 'İngilizce - Türkçe Çeviri';
      case QuestionCategory.translationTrEn:
        return 'Türkçe - İngilizce Çeviri';
      case QuestionCategory.reading:
        return 'Paragraf / Okuma Parçası';
      case QuestionCategory.dialogue:
        return 'Diyalog Tamamlama';
      case QuestionCategory.restatement:
        return 'Yakın Anlamlı Cümle';
      case QuestionCategory.paragraphCompletion:
        return 'Paragraf Tamamlama';
      case QuestionCategory.irrelevantSentence:
        return 'Anlam Bütünlüğünü Bozan Cümle';
    }
  }

  String get titleTr => title;

  IconData get icon {
    switch (this) {
      case QuestionCategory.vocabulary:
        return Icons.menu_book;
      case QuestionCategory.grammar:
        return Icons.spellcheck;
      case QuestionCategory.sentenceCompletion:
        return Icons.extension;
      case QuestionCategory.translationEnTr:
      case QuestionCategory.translationTrEn:
        return Icons.translate;
      case QuestionCategory.reading:
        return Icons.article;
      case QuestionCategory.dialogue:
        return Icons.forum;
      case QuestionCategory.restatement:
        return Icons.sync_alt;
      case QuestionCategory.paragraphCompletion:
        return Icons.post_add;
      case QuestionCategory.irrelevantSentence:
        return Icons.remove_circle_outline;
    }
  }

  String get iconName {
    switch (this) {
      case QuestionCategory.vocabulary:
        return 'menu_book';
      case QuestionCategory.grammar:
        return 'spellcheck';
      case QuestionCategory.sentenceCompletion:
        return 'extension';
      case QuestionCategory.translationEnTr:
      case QuestionCategory.translationTrEn:
        return 'translate';
      case QuestionCategory.reading:
        return 'article';
      case QuestionCategory.dialogue:
        return 'forum';
      case QuestionCategory.restatement:
        return 'sync_alt';
      case QuestionCategory.paragraphCompletion:
        return 'post_add';
      case QuestionCategory.irrelevantSentence:
        return 'remove_circle_outline';
    }
  }
}

class Question {
  final String id;
  final QuestionCategory category;
  final String? passage; // Optional reading passage
  final String questionText;
  final List<String> options; // Exactly 5 options: A, B, C, D, E
  final int correctIndex; // 0 = A, 1 = B, 2 = C, 3 = D, 4 = E
  final String explanation; // Detailed Turkish explanation
  final String difficulty; // Kolay, Orta, İleri
  final bool isPremiumOnly;

  const Question({
    required this.id,
    required this.category,
    this.passage,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = 'İleri',
    this.isPremiumOnly = false,
  });

  Question copyWith({
    String? id,
    QuestionCategory? category,
    String? passage,
    String? questionText,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    String? difficulty,
    bool? isPremiumOnly,
  }) {
    return Question(
      id: id ?? this.id,
      category: category ?? this.category,
      passage: passage ?? this.passage,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      isPremiumOnly: isPremiumOnly ?? this.isPremiumOnly,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'passage': passage,
      'questionText': questionText,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'difficulty': difficulty,
      'isPremiumOnly': isPremiumOnly,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      category: QuestionCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => QuestionCategory.vocabulary,
      ),
      passage: json['passage'] as String?,
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e.toString()).toList(),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String,
      difficulty: json['difficulty'] as String? ?? 'İleri',
      isPremiumOnly: json['isPremiumOnly'] as bool? ?? false,
    );
  }
}
