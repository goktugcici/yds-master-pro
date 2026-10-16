import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/question.dart';
import '../../providers/question_provider.dart';
import '../practice/practice_quiz_screen.dart';

class MistakeNotebookScreen extends ConsumerStatefulWidget {
  const MistakeNotebookScreen({super.key});

  @override
  ConsumerState<MistakeNotebookScreen> createState() => _MistakeNotebookScreenState();
}

class _MistakeNotebookScreenState extends ConsumerState<MistakeNotebookScreen> {
  QuestionCategory? _selectedCategory;
  final Set<String> _expandedQuestionIds = {};

  @override
  Widget build(BuildContext context) {
    final questionState = ref.watch(questionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get all mistake questions
    final mistakeIds = questionState.mistakeQuestionIds;
    final allMistakes = questionState.allQuestions
        .where((q) => mistakeIds.contains(q.id))
        .toList();

    // Filter by selected category if any
    final filteredMistakes = _selectedCategory == null
        ? allMistakes
        : allMistakes.where((q) => q.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.menu_book, color: AppColors.error, size: 22),
            const SizedBox(width: 8),
            const Text('Akıllı Hata Defteri'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.error.withOpacity(0.4)),
              ),
              child: Text(
                '${allMistakes.length}',
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: allMistakes.isEmpty
          ? _buildEmptyState(context, isDark)
          : Column(
              children: [
                // Top Banner with Retest CTA
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB91C1C), Color(0xFFEF4444)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.replay, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${filteredMistakes.length} Yanlış Soru Var',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Hatalarını telafi edip kalıcı öğren',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: filteredMistakes.isEmpty
                            ? null
                            : () => _startRetest(context, filteredMistakes),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFB91C1C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Telafi Testi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text('Tümü (${allMistakes.length})'),
                          selected: _selectedCategory == null,
                          onSelected: (_) {
                            setState(() => _selectedCategory = null);
                          },
                          selectedColor: AppColors.primaryLight.withOpacity(0.2),
                        ),
                      ),
                      ...QuestionCategory.values.where((cat) {
                        return allMistakes.any((q) => q.category == cat);
                      }).map((cat) {
                        final count = allMistakes.where((q) => q.category == cat).length;
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text('${cat.title} ($count)'),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() => _selectedCategory = cat);
                            },
                            selectedColor: AppColors.primaryLight.withOpacity(0.2),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Mistake Questions List
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMistakes.length,
                    itemBuilder: (context, index) {
                      final q = filteredMistakes[index];
                      final isExpanded = _expandedQuestionIds.contains(q.id);

                      return _buildMistakeCard(
                        context: context,
                        question: q,
                        isDark: isDark,
                        isExpanded: isExpanded,
                        onToggleExpand: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedQuestionIds.remove(q.id);
                            } else {
                              _expandedQuestionIds.add(q.id);
                            }
                          });
                        },
                        onRetakeSingle: () {
                          _startRetest(context, [q]);
                        },
                        onRemoveMistake: () async {
                          await ref
                              .read(questionProvider.notifier)
                              .removeMistake(q.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Soru hata defterinden kaldırıldı.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, size: 72, color: AppColors.success),
            ),
            const SizedBox(height: 24),
            const Text(
              'Harika! Hata Defteriniz Boş',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Soru bankasında veya denemelerde yanlış yaptığınız sorular burada toplanır ve telafi testleriyle eksiklerinizi kapatmanızı sağlar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('Soru Bankasına Dön'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ).animate().fade().scale(),
      ),
    );
  }

  Widget _buildMistakeCard({
    required BuildContext context,
    required Question question,
    required bool isDark,
    required bool isExpanded,
    required VoidCallback onToggleExpand,
    required VoidCallback onRetakeSingle,
    required VoidCallback onRemoveMistake,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Category Badge & Remove Action
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question.category.title,
                    style: const TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'remove') onRemoveMistake();
                    if (value == 'solve') onRetakeSingle();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'solve',
                      child: Row(
                        children: [
                          Icon(Icons.replay, size: 18, color: AppColors.primaryLight),
                          SizedBox(width: 8),
                          Text('Bu Soruyu Çöz'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          SizedBox(width: 8),
                          Text('Defterden Çıkar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Question Text
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (question.passage != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      question.passage!,
                      maxLines: isExpanded ? null : 3,
                      overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, height: 1.45),
                    ),
                  ),
                ],
                Text(
                  question.questionText,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.4),
                ),
              ],
            ),
          ),

          // Options (Collapsed: correct answer preview, Expanded: full options list)
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(question.options.length, (optIdx) {
                  final isCorrect = optIdx == question.correctIndex;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? AppColors.success.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCorrect
                            ? AppColors.success
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 16,
                          color: isCorrect ? AppColors.success : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            question.options[optIdx],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                              color: isCorrect ? AppColors.success : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            // Explanation
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primaryLight),
                      SizedBox(width: 6),
                      Text(
                        'Türkçe Çözüm & Çeldirici Analizi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question.explanation,
                    style: const TextStyle(fontSize: 12.5, height: 1.45),
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: AppColors.success),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Doğru Cevap: ${question.options[question.correctIndex]}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Footer Action Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onToggleExpand,
                  icon: Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 18,
                  ),
                  label: Text(
                    isExpanded ? 'Detayları Gizle' : 'Çözümü & Şıkları Gör',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onRetakeSingle,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Şimdi Çöz', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startRetest(BuildContext context, List<Question> questions) {
    ref.read(questionProvider.notifier).startCustomQuiz(questions);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PracticeQuizScreen(title: 'Hatalarımdan Telafi Testi'),
      ),
    );
  }
}
