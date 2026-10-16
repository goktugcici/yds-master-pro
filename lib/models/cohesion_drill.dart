enum CohesionType {
  irrelevantSentence, // Anlam akışını bozan cümle (I, II, III, IV, V)
  paragraphCompletion, // Boşluğa uygun cümleyi yerleştirme
}

class CohesionDrill {
  final String id;
  final CohesionType type;
  final String title;
  final String topic; // Tıp, Çevre, Tarih, Teknoloji, Psikoloji vb.
  final String passage; // Full passage with either (I), (II)... or [ ______ ]
  final List<String> options;
  final int correctIndex;
  final List<String> keyClues; // e.g., ["However", "These findings", "In contrast"]
  final String tacticExplanation;
  final String translation;

  const CohesionDrill({
    required this.id,
    required this.type,
    required this.title,
    required this.topic,
    required this.passage,
    required this.options,
    required this.correctIndex,
    required this.keyClues,
    required this.tacticExplanation,
    required this.translation,
  });

  String get typeLabel => type == CohesionType.irrelevantSentence
      ? 'Anlam Akışını Bozan Cümle'
      : 'Paragraf Tamamlama';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'topic': topic,
      'passage': passage,
      'options': options,
      'correctIndex': correctIndex,
      'keyClues': keyClues,
      'tacticExplanation': tacticExplanation,
      'translation': translation,
    };
  }

  factory CohesionDrill.fromJson(Map<String, dynamic> json) {
    return CohesionDrill(
      id: json['id'] as String,
      type: json['type'] == 'irrelevantSentence'
          ? CohesionType.irrelevantSentence
          : CohesionType.paragraphCompletion,
      title: json['title'] as String,
      topic: json['topic'] as String,
      passage: json['passage'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctIndex: json['correctIndex'] as int,
      keyClues: (json['keyClues'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      tacticExplanation: json['tacticExplanation'] as String,
      translation: json['translation'] as String,
    );
  }
}
