import 'question.dart';

class GrammarExample {
  final String english;
  final String turkish;
  final String analysis;

  const GrammarExample({
    required this.english,
    required this.turkish,
    required this.analysis,
  });
}

class GrammarTopic {
  final String id;
  final String title;
  final String subtitle;
  final QuestionCategory category;
  final String level; // B1, B2, C1
  final List<String> goldenRules;
  final List<String> examTraps;
  final List<GrammarExample> examples;
  final List<String> keyFormulas;

  const GrammarTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    this.level = 'B2',
    required this.goldenRules,
    required this.examTraps,
    required this.examples,
    required this.keyFormulas,
  });
}
