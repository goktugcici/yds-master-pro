import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../providers/exam_provider.dart';
import '../../providers/subscription_provider.dart';
import '../paywall/paywall_screen.dart';
import 'exam_active_screen.dart';

class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final history = ref.watch(examHistoryProvider);
    final exams = ExamNotifier.getAvailableExams();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Deneme Sınavları'),
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
                colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Colors.white, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'ÖSYM Standartlarında Denemeler',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Gerçek sınav süresiyle kendini test et, YDS puanını ve harf notunu (A-E) anında öğren.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Mevcut Deneme Sınavları',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...exams.map((exam) {
            final isLocked = exam.isPremiumOnly && !sub.isPro;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${exam.durationMinutes} Dakika',
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${exam.questionCount} Soru',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Spacer(),
                        if (isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                    ),
                    const SizedBox(height: 10),
                    Text(
                      exam.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exam.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLocked) {
                            PaywallScreen.show(context);
                          } else {
                            _startExam(context, ref, exam);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLocked ? AppColors.premiumGold : AppColors.primaryLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isLocked ? Icons.lock : Icons.play_arrow, size: 18),
                            const SizedBox(width: 6),
                            Text(isLocked ? 'PRO ile Kilidi Aç' : 'Sınavı Başlat'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Exam History
          if (history.isNotEmpty) ...[
            const Text(
              'Tamamlanan Deneme Geçmişi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...history.map((result) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        result.score.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                            result.examTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Doğru: ${result.correctCount} | Yanlış: ${result.wrongCount} | Seviye: ${result.letterGrade}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  void _startExam(BuildContext context, WidgetRef ref, Exam exam) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(exam.title),
        content: Text(
          'Sınav süresi ${exam.durationMinutes} dakikadır. Başlattığınızda sayaç geriye doğru saymaya başlayacaktır. Hazır mısınız?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(examStateProvider.notifier).startExam(exam);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExamActiveScreen()),
              );
            },
            child: const Text('Başlat'),
          ),
        ],
      ),
    );
  }
}
