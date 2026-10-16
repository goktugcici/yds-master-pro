import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/question.dart';
import '../../providers/exam_provider.dart';
import '../../providers/question_provider.dart';
import '../../providers/stats_provider.dart';
import '../practice/practice_quiz_screen.dart';

class DetailedStatsScreen extends ConsumerWidget {
  const DetailedStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final exams = ref.watch(examHistoryProvider);
    final targetScore = ref.watch(targetScoreProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weakest = stats.weakestCategory;
    final weakestAcc = weakest != null ? (stats.categoryAccuracy[weakest] ?? 0.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performans & Zayıf Halka Analizi'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Score & Target Overview Card
          _buildScoreOverviewCard(stats, targetScore),

          const SizedBox(height: 14),

          // YDS Golden Rule Note
          _buildYdsGoldenRuleCard(),

          const SizedBox(height: 20),

          // Zayıf Halka Radar
          if (weakest != null)
            _buildWeakestCard(context, ref, weakest, weakestAcc, isDark),

          const SizedBox(height: 24),

          // Category-by-Category Mastery Section
          const Text(
            'Kategori Bazlı Başarı Analizi',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Tüm 10 YDS kategorisindeki doğruluk oranların ve tamamlanma durumun',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
            ),
          ),
          const SizedBox(height: 14),

          for (final cat in QuestionCategory.values)
            _buildCategoryRow(context, ref, cat, stats, isDark),

          const SizedBox(height: 20),

          // Exam History
          if (exams.isNotEmpty) ...[
            const Text(
              'Tamamlanan Deneme Sınavları',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (final res in exams)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${res.score.toInt()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            res.examTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${res.correctCount} Doğru • ${res.wrongCount} Yanlış • ${res.emptyCount} Boş',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      res.letterGrade.split(' ')[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreOverviewCard(OverallStats stats, int targetScore) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tahmini YDS Puanı',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        stats.totalSolved >= 5
                            ? stats.estimatedScore.toStringAsFixed(1)
                            : '--',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' / 100',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hedef Puan',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$targetScore',
                      style: const TextStyle(
                        color: AppColors.premiumGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCol('Toplam Çözülen', '${stats.totalSolved} Soru'),
              _buildStatCol('Doğru Sayısı', '${stats.totalCorrect}'),
              _buildStatCol('Başarı Oranı', '%${stats.accuracyPercentage.toStringAsFixed(1)}'),
              _buildStatCol('Harf Notu', stats.letterGrade.split(' ')[0]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYdsGoldenRuleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: AppColors.info, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'ÖSYM Bilgisi: YDS\'de yanlışlar doğruyu götürmez. Her net tam 1.25 puandır.',
              style: TextStyle(fontSize: 12, color: AppColors.info, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakestCard(
    BuildContext context,
    WidgetRef ref,
    QuestionCategory weakest,
    double weakestAcc,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1515) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF87171).withOpacity(0.6), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zayıf Halka Tespit Edildi!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    Text(
                      'En çok puan kaybettiğin alan: ${weakest.titleTr}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '%${weakestAcc.toStringAsFixed(1)} Başarı',
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Bu soru tipinde netlerini yükselterek YDS puanını en az 6-8 puan artırabilirsin.',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(questionNotifierProvider.notifier).selectCategory(weakest);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PracticeQuizScreen(title: weakest.titleTr),
                  ),
                );
              },
              icon: const Icon(Icons.flash_on, size: 18),
              label: Text('${weakest.titleTr} 10 Soruluk Telafi Testi Çöz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    WidgetRef ref,
    QuestionCategory cat,
    OverallStats stats,
    bool isDark,
  ) {
    final acc = stats.categoryAccuracy[cat] ?? 0;
    final solvedCount = stats.categoryTotalSolved[cat] ?? 0;
    final color = acc >= 75
        ? const Color(0xFF10B981)
        : (acc >= 50 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(cat.icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.titleTr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '$solvedCount Soru Çözüldü',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '%${acc.toStringAsFixed(1)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 14),
                onPressed: () {
                  ref.read(questionNotifierProvider.notifier).selectCategory(cat);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PracticeQuizScreen(title: cat.titleTr),
                    ),
                  );
                },
                tooltip: 'Pratik Yap',
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (acc / 100.0).clamp(0.0, 1.0),
              backgroundColor: isDark ? Colors.white12 : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
