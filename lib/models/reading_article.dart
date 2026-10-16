class ReadingVocab {
  final String english;
  final String turkish;
  final String definition;

  const ReadingVocab({
    required this.english,
    required this.turkish,
    required this.definition,
  });
}

class ReadingQuestion {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ReadingQuestion({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class ReadingArticle {
  final String id;
  final String title;
  final String topic; // Bilim, Çevre, Tarih, Teknoloji, Psikoloji
  final String level; // B2, C1
  final int readTimeMinutes;
  final String contentEn;
  final String contentTr;
  final List<ReadingVocab> vocabulary;
  final List<ReadingQuestion> questions;
  final bool isProOnly;

  const ReadingArticle({
    required this.id,
    required this.title,
    required this.topic,
    required this.level,
    required this.readTimeMinutes,
    required this.contentEn,
    required this.contentTr,
    required this.vocabulary,
    required this.questions,
    this.isProOnly = false,
  });
}
