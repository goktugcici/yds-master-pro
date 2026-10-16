class Word {
  final String id;
  final String english;
  final String turkish;
  final String partOfSpeech; // verb, noun, adj, adv, phrasal_verb, collocation
  final String exampleSentence;
  final String exampleTranslation;
  final List<String> synonyms;
  final List<String> antonyms;
  final String level; // B1, B2, C1
  final int srsLevel; // 0 = New, 1..5 = Spaced repetition stage
  final bool isLearned;
  final bool isFavorite;

  const Word({
    required this.id,
    required this.english,
    required this.turkish,
    required this.partOfSpeech,
    required this.exampleSentence,
    required this.exampleTranslation,
    this.synonyms = const [],
    this.antonyms = const [],
    this.level = 'B2',
    this.srsLevel = 0,
    this.isLearned = false,
    this.isFavorite = false,
  });

  Word copyWith({
    String? id,
    String? english,
    String? turkish,
    String? partOfSpeech,
    String? exampleSentence,
    String? exampleTranslation,
    List<String>? synonyms,
    List<String>? antonyms,
    String? level,
    int? srsLevel,
    bool? isLearned,
    bool? isFavorite,
  }) {
    return Word(
      id: id ?? this.id,
      english: english ?? this.english,
      turkish: turkish ?? this.turkish,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      level: level ?? this.level,
      srsLevel: srsLevel ?? this.srsLevel,
      isLearned: isLearned ?? this.isLearned,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english': english,
      'turkish': turkish,
      'partOfSpeech': partOfSpeech,
      'exampleSentence': exampleSentence,
      'exampleTranslation': exampleTranslation,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'level': level,
      'srsLevel': srsLevel,
      'isLearned': isLearned,
      'isFavorite': isFavorite,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String,
      english: json['english'] as String,
      turkish: json['turkish'] as String,
      partOfSpeech: json['partOfSpeech'] as String? ?? 'verb',
      exampleSentence: json['exampleSentence'] as String? ?? '',
      exampleTranslation: json['exampleTranslation'] as String? ?? '',
      synonyms: (json['synonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      antonyms: (json['antonyms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      level: json['level'] as String? ?? 'B2',
      srsLevel: json['srsLevel'] as int? ?? 0,
      isLearned: json['isLearned'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
