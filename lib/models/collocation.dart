class Collocation {
  final String id;
  final String word; // e.g. "rely", "capable", "prevent"
  final String preposition; // e.g. "on", "of", "from", "to"
  final String meaningTr; // e.g. "güvenmek, bel bağlamak"
  final String exampleSentence; // "Modern societies rely on automated energy grids."
  final String partOfSpeech; // "verb", "adjective", "noun"
  final String tip; // Exam tip / synonyms

  const Collocation({
    required this.id,
    required this.word,
    required this.preposition,
    required this.meaningTr,
    required this.exampleSentence,
    required this.partOfSpeech,
    required this.tip,
  });

  String get fullPhrase => '$word $preposition';
}
