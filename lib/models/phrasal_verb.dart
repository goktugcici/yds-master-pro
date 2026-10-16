class PhrasalVerb {
  final String id;
  final String verb;
  final String particles; // e.g. "out", "up", "with", "for"
  final String turkish;
  final String academicMeaning;
  final List<String> synonyms;
  final String exampleSentence;
  final String exampleTranslation;
  final String osymTrapWarning;
  final String level; // B2, C1

  const PhrasalVerb({
    required this.id,
    required this.verb,
    required this.particles,
    required this.turkish,
    required this.academicMeaning,
    this.synonyms = const [],
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.osymTrapWarning,
    this.level = 'C1',
  });

  String get fullPhrase => '$verb $particles';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verb': verb,
      'particles': particles,
      'turkish': turkish,
      'academicMeaning': academicMeaning,
      'synonyms': synonyms,
      'exampleSentence': exampleSentence,
      'exampleTranslation': exampleTranslation,
      'osymTrapWarning': osymTrapWarning,
      'level': level,
    };
  }

  factory PhrasalVerb.fromJson(Map<String, dynamic> json) {
    return PhrasalVerb(
      id: json['id'] as String,
      verb: json['verb'] as String,
      particles: json['particles'] as String,
      turkish: json['turkish'] as String,
      academicMeaning: json['academicMeaning'] as String,
      synonyms: (json['synonyms'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      exampleSentence: json['exampleSentence'] as String,
      exampleTranslation: json['exampleTranslation'] as String,
      osymTrapWarning: json['osymTrapWarning'] as String? ?? '',
      level: json['level'] as String? ?? 'C1',
    );
  }
}
