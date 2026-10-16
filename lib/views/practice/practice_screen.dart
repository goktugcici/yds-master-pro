import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/question.dart';
import '../../providers/question_provider.dart';
import '../../providers/subscription_provider.dart';
import '../mistakes/mistake_notebook_screen.dart';
import '../paywall/paywall_screen.dart';
import 'practice_quiz_screen.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final questionState = ref.watch(questionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {
        'category': QuestionCategory.vocabulary,
        'title': 'Kelime Bilgisi',
        'desc': 'Fiil, isim, sıfat, phrasal verb ve collocations',
        'icon': Icons.menu_book,
        'isProOnly': false,
      },
      {
        'category': QuestionCategory.grammar,
        'title': 'Gramer & Dilbilgisi',
        'desc': 'Bağlaçlar, edatlar, tenseler ve devrik yapılar',
        'icon': Icons.spellcheck,
        'isProOnly': false,
      },
      {
        'category': QuestionCategory.sentenceCompletion,
        'title': 'Cümle Tamamlama',
        'desc': 'Neden-sonuç, zıtlık ve koşul cümleleri',
        'icon': Icons.extension,
        'isProOnly': false,
      },
      {
        'category': QuestionCategory.translationEnTr,
        'title': 'İngilizce - Türkçe Çeviri',
        'desc': 'Özne ve yüklem odaklı hızlı çeviri soruları',
        'icon': Icons.translate,
        'isProOnly': false,
      },
      {
        'category': QuestionCategory.translationTrEn,
        'title': 'Türkçe - İngilizce Çeviri',
        'desc': 'Doğru edat ve tenselerle İngilizceye çeviri',
        'icon': Icons.g_translate,
        'isProOnly': true,
      },
      {
        'category': QuestionCategory.reading,
        'title': 'Paragraf & Okuma Parçası',
        'desc': 'Akademik metinler ve çıkarım soruları',
        'icon': Icons.article,
        'isProOnly': true,
      },
      {
        'category': QuestionCategory.restatement,
        'title': 'Yakın Anlamlı Cümle',
        'desc': 'Aynı düşünceyi farklı yapıyla ifade etme',
        'icon': Icons.sync_alt,
        'isProOnly': true,
      },
      {
        'category': QuestionCategory.dialogue,
        'title': 'Diyalog Tamamlama',
        'desc': 'Bağlama ve nezaket kurallarına uygun yanıtlar',
        'icon': Icons.forum,
        'isProOnly': true,
      },
      {
        'category': QuestionCategory.paragraphCompletion,
        'title': 'Paragraf Tamamlama',
        'desc': 'Düşünce akışına göre boşluğa uygun cümle',
        'icon': Icons.post_add,
        'isProOnly': true,
      },
      {
        'category': QuestionCategory.irrelevantSentence,
        'title': 'Anlamı Bozan Cümle',
        'desc': 'Paragrafın ana fikrinden sapan cümleyi bulma',
        'icon': Icons.remove_circle_outline,
        'isProOnly': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Soru Bankası'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Mistake notebook banner if any
          if (questionState.mistakeQuestionIds.isNotEmpty) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MistakeNotebookScreen()),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.replay, color: AppColors.error, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${questionState.mistakeQuestionIds.length} Yanlış Soru Hata Defterinde!',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Telafi testi çözerek eksiklerini kapat.',
                            style: TextStyle(fontSize: 11.5, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.error),
                  ],
                ),
              ),
            ),
          ],

          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryLight.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primaryLight),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'ÖSYM\'nin YDS sınavında sorduğu 11 ana soru tipine göre ayrılmış soru havuzu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : AppColors.textLightPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          ...categories.map((cat) {
            final categoryEnum = cat['category'] as QuestionCategory;
            final isProLocked = (cat['isProOnly'] as bool) && !sub.isPro;
            final count = questionState.allQuestions
                .where((q) => q.category == categoryEnum)
                .length;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isProLocked
                        ? Colors.grey.withOpacity(0.15)
                        : AppColors.primaryLight.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: isProLocked ? Colors.grey : AppColors.primaryLight,
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      cat['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    if (isProLocked) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.premiumGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${cat['desc']} • $count Soru',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                trailing: isProLocked
                    ? const Icon(Icons.lock, color: AppColors.premiumGold, size: 20)
                    : const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  if (isProLocked) {
                    PaywallScreen.show(context);
                  } else {
                    ref.read(questionProvider.notifier).selectCategory(categoryEnum);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PracticeQuizScreen(
                          title: cat['title'] as String,
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
