import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/question_provider.dart';

class PracticeQuizScreen extends ConsumerWidget {
  final String title;

  const PracticeQuizScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questionProvider);
    final question = state.currentQuestion;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 64, color: AppColors.success),
              const SizedBox(height: 16),
              const Text(
                'Bu kategorideki tüm soruları tamamladınız!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kategorilere Dön'),
              ),
            ],
          ),
        ),
      );
    }

    final totalQuestions = state.activeQuestions.length;
    final isBookmarked = state.bookmarkedQuestionIds.contains(question.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('$title (${state.currentIndex + 1}/$totalQuestions)'),
        actions: [
          IconButton(
            icon: Icon(
              state.questionNotes.containsKey(question.id)
                  ? Icons.sticky_note_2
                  : Icons.note_add_outlined,
              color: state.questionNotes.containsKey(question.id)
                  ? const Color(0xFFF59E0B)
                  : null,
            ),
            tooltip: 'Soruya Not Ekle',
            onPressed: () => _showNoteDialog(
              context,
              ref,
              question.id,
              state.questionNotes[question.id],
            ),
          ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.primaryLight : null,
            ),
            onPressed: () {
              ref.read(questionProvider.notifier).toggleBookmark(question.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Linear progress
          LinearProgressIndicator(
            value: (state.currentIndex + 1) / totalQuestions,
            backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
            color: AppColors.primaryLight,
            minHeight: 4,
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reading passage box if exists
                  if (question.passage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.menu_book, size: 16, color: AppColors.primaryLight),
                              SizedBox(width: 6),
                              Text(
                                'OKUMA PARÇASI',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryLight,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.passage!,
                            style: const TextStyle(fontSize: 13.5, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // Question Text
                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5 Options A, B, C, D, E
                  ...List.generate(question.options.length, (index) {
                    final optionText = question.options[index];
                    final isSelected = state.selectedOptionIndex == index;
                    final isCorrect = index == question.correctIndex;

                    Color backgroundColor = isDark ? AppColors.cardDark : Colors.white;
                    Color borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
                    Color textColor = isDark ? Colors.white : AppColors.textLightPrimary;
                    IconData? statusIcon;

                    if (state.hasSubmitted) {
                      if (isCorrect) {
                        backgroundColor = AppColors.success.withOpacity(0.15);
                        borderColor = AppColors.success;
                        textColor = AppColors.success;
                        statusIcon = Icons.check_circle;
                      } else if (isSelected && !isCorrect) {
                        backgroundColor = AppColors.error.withOpacity(0.15);
                        borderColor = AppColors.error;
                        textColor = AppColors.error;
                        statusIcon = Icons.cancel;
                      }
                    } else if (isSelected) {
                      backgroundColor = AppColors.primaryLight.withOpacity(0.12);
                      borderColor = AppColors.primaryLight;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: state.hasSubmitted
                            ? null
                            : () {
                                ref.read(questionProvider.notifier).selectOption(index);
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (statusIcon != null)
                                Icon(statusIcon, color: borderColor, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Submit Answer Button (Before submission)
                  if (!state.hasSubmitted) ...[
                    ElevatedButton(
                      onPressed: state.selectedOptionIndex == null
                          ? null
                          : () {
                              ref.read(questionProvider.notifier).submitAnswer();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Cevabı Onayla',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],

                  // Solution Explanation Drawer (After submission)
                  if (state.hasSubmitted) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: state.isCurrentCorrect
                            ? const Color(0xFFF0FDF4)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: state.isCurrentCorrect
                              ? AppColors.success.withOpacity(0.4)
                              : AppColors.error.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                state.isCurrentCorrect ? Icons.check_circle : Icons.error,
                                color: state.isCurrentCorrect ? AppColors.success : AppColors.error,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.isCurrentCorrect ? 'Tebrikler, Doğru Cevap!' : 'Yanlış Cevap',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: state.isCurrentCorrect
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            question.explanation,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fade().slideY(begin: 0.1, end: 0),

                    // Question Note Post-It Card
                    if (state.questionNotes.containsKey(question.id)) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF3B2F08) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFF59E0B).withOpacity(0.6),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.sticky_note_2, color: Color(0xFFD97706), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kişisel Çalışma Notunuz',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFFD97706),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.questionNotes[question.id]!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white70 : const Color(0xFF78350F),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 16, color: Color(0xFFD97706)),
                              onPressed: () => _showNoteDialog(
                                context,
                                ref,
                                question.id,
                                state.questionNotes[question.id],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Next / Prev controls
                    Row(
                      children: [
                        if (state.currentIndex > 0) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ref.read(questionProvider.notifier).previousQuestion();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Önceki'),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.currentIndex + 1 < totalQuestions
                                ? () {
                                    ref.read(questionProvider.notifier).nextQuestion();
                                  }
                                : () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              state.currentIndex + 1 < totalQuestions
                                  ? 'Sonraki Soru'
                                  : 'Kategoriyi Bitir',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoteDialog(
    BuildContext context,
    WidgetRef ref,
    String questionId,
    String? existingNote,
  ) {
    final controller = TextEditingController(text: existingNote ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.sticky_note_2, color: Color(0xFFF59E0B)),
            SizedBox(width: 8),
            Text('Soruya Not Ekle'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bu soruya özel hatırlatma, bağlaç kuralı veya kelime notunu yaz:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Örn: Although arkasından tam cümle alır, despite isim alır...',
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          if (existingNote != null && existingNote.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(questionProvider.notifier).deleteQuestionNote(questionId);
                Navigator.of(ctx).pop();
              },
              child: const Text('Notu Sil', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(questionProvider.notifier).saveQuestionNote(questionId, controller.text);
              Navigator.of(ctx).pop();
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
