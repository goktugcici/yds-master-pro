enum TranslationDirection {
  englishToTurkish, // İngilizce -> Türkçe (YDS Soru 37-39)
  turkishToEnglish, // Türkçe -> İngilizce (YDS Soru 40-42)
}

class SentenceComponent {
  final String label; // "Özne (Subject)", "Ana Fiil (Main Verb)", "Zarf Cümleciği", "Nesne / Tümleç"
  final String text;
  final String roleCode; // 'subject', 'verb', 'object', 'clause'

  const SentenceComponent({
    required this.label,
    required this.text,
    required this.roleCode,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'text': text,
        'roleCode': roleCode,
      };

  factory SentenceComponent.fromJson(Map<String, dynamic> json) =>
      SentenceComponent(
        label: json['label'] as String,
        text: json['text'] as String,
        roleCode: json['roleCode'] as String? ?? 'clause',
      );
}

class TranslationDrill {
  final String id;
  final TranslationDirection direction;
  final String topic; // Tıp, Çevre, Tarih, Psikoloji, Teknoloji vb.
  final String originalSentence;
  final List<SentenceComponent> components;
  final List<String> options;
  final int correctIndex;
  final Map<int, String> distractorAnalysis;
  final String goldenRule;
  final String fullTranslation;

  const TranslationDrill({
    required this.id,
    required this.direction,
    required this.topic,
    required this.originalSentence,
    required this.components,
    required this.options,
    required this.correctIndex,
    required this.distractorAnalysis,
    required this.goldenRule,
    required this.fullTranslation,
  });

  String get directionLabel =>
      direction == TranslationDirection.englishToTurkish
          ? 'İngilizce ➔ Türkçe (EN-TR)'
          : 'Türkçe ➔ İngilizce (TR-EN)';

  Map<String, dynamic> toJson() => {
        'id': id,
        'direction': direction.name,
        'topic': topic,
        'originalSentence': originalSentence,
        'components': components.map((c) => c.toJson()).toList(),
        'options': options,
        'correctIndex': correctIndex,
        'distractorAnalysis': distractorAnalysis.map((k, v) => MapEntry(k.toString(), v)),
        'goldenRule': goldenRule,
        'fullTranslation': fullTranslation,
      };

  factory TranslationDrill.fromJson(Map<String, dynamic> json) {
    final distMapRaw = json['distractorAnalysis'] as Map<String, dynamic>? ?? {};
    final distMap = distMapRaw.map((k, v) => MapEntry(int.parse(k), v as String));

    return TranslationDrill(
      id: json['id'] as String,
      direction: json['direction'] == 'englishToTurkish'
          ? TranslationDirection.englishToTurkish
          : TranslationDirection.turkishToEnglish,
      topic: json['topic'] as String,
      originalSentence: json['originalSentence'] as String,
      components: (json['components'] as List<dynamic>)
          .map((c) => SentenceComponent.fromJson(c as Map<String, dynamic>))
          .toList(),
      options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctIndex: json['correctIndex'] as int,
      distractorAnalysis: distMap,
      goldenRule: json['goldenRule'] as String,
      fullTranslation: json['fullTranslation'] as String,
    );
  }
}
