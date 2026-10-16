import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_grammar_topics.dart';
import '../../models/question.dart';
import '../../providers/question_provider.dart';
import '../practice/practice_quiz_screen.dart';

class GrammarStudyScreen extends ConsumerStatefulWidget {
  const GrammarStudyScreen({super.key});

  @override
  ConsumerState<GrammarStudyScreen> createState() => _GrammarStudyScreenState();
}

class _GrammarStudyScreenState extends ConsumerState<GrammarStudyScreen> {
  String _searchQuery = '';
  String? _expandedTopicId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredTopics = defaultGrammarTopics.where((topic) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return topic.title.toLowerCase().contains(q) ||
          topic.subtitle.toLowerCase().contains(q) ||
          topic.goldenRules.any((r) => r.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Gramer Rehberi & Notlar'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'YDS Altın Gramer Kuralları',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ÖSYM\'nin her yıl sorduğu bağlaç, tense, modal ve devrik yapı formülleri.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search Field
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Gramer konusu veya kural ara (örn: since, modal, devrik)...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: isDark ? AppColors.cardDark : Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Topics List
          ...filteredTopics.map((topic) {
            final isExpanded = _expandedTopicId == topic.id;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isExpanded
                      ? const Color(0xFF0D9488)
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isExpanded ? 1.5 : 1.0,
                ),
                boxShadow: isExpanded
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D9488).withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  key: Key(topic.id),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expandedTopicId = expanded ? topic.id : null;
                    });
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.spellcheck, color: Color(0xFF0D9488), size: 22),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          topic.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          topic.level,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    topic.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 14),

                    // Golden Rules Box
                    _buildSectionHeader('Altın Kurallar', Icons.star, const Color(0xFFF59E0B)),
                    const SizedBox(height: 8),
                    ...topic.goldenRules.map((rule) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle, size: 16, color: Color(0xFF10B981)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  rule,
                                  style: const TextStyle(fontSize: 13, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 14),

                    // Key Formulas Box
                    if (topic.keyFormulas.isNotEmpty) ...[
                      _buildSectionHeader('Kritik Sınav Formülleri', Icons.functions, const Color(0xFF3B82F6)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? Colors.white12 : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: topic.keyFormulas.map((f) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  '• $f',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )).toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Exam Pitfalls
                    if (topic.examTraps.isNotEmpty) ...[
                      _buildSectionHeader('ÖSYM Çeldirici Tuzakları', Icons.warning_amber, const Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: topic.examTraps.map((trap) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.close, size: 16, color: Color(0xFFEF4444)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        trap,
                                        style: const TextStyle(fontSize: 12.5, color: Color(0xFFDC2626)),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Examples
                    _buildSectionHeader('YDS Seviye Örnek Cümleler', Icons.format_quote, const Color(0xFF8B5CF6)),
                    const SizedBox(height: 8),
                    ...topic.examples.map((ex) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ex.english,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ex.turkish,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '💡 Not: ${ex.analysis}',
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF0D9488)),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 14),

                    // Practice Quiz Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref.read(questionNotifierProvider.notifier).selectCategory(QuestionCategory.grammar);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PracticeQuizScreen(title: topic.title),
                            ),
                          );
                        },
                        icon: const Icon(Icons.flash_on, size: 18),
                        label: Text('${topic.title} Soru Çöz'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D9488),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
