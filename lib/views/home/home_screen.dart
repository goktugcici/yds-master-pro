import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../models/question.dart';
import '../../providers/question_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/vocabulary_provider.dart';
import '../mistakes/mistake_notebook_screen.dart';
import '../paywall/paywall_screen.dart';
import '../reading/reading_hub_screen.dart';
import '../stats/detailed_stats_screen.dart';
import '../strategies/strategy_guide_screen.dart';
import '../vocabulary/vocab_quiz_screen.dart';
import '../vocabulary/vocab_match_screen.dart';

class HomeScreen extends ConsumerWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final sub = ref.watch(subscriptionProvider);
    final vocab = ref.watch(vocabularyProvider);
    final questionState = ref.watch(questionProvider);
    final targetScore = ref.watch(targetScoreProvider);
    final targetDate = ref.watch(targetExamDateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final daysLeft = targetDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YDS Master PRO',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                Text(
                  sub.isPro
                      ? '👑 PRO Üyelik Aktif'
                      : 'Hedef: $targetScore Puan (${_getLevelLetter(targetScore)})',
                  style: TextStyle(
                    fontSize: 11,
                    color: sub.isPro ? AppColors.premiumGoldDark : AppColors.textLightSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Daily Streak Badge
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warning.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: AppColors.warning, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${stats.streakDays} Gün',
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // PRO Subscription Banner (if free) or Active Pro Status
              if (!sub.isPro) ...[
              GestureDetector(
                onTap: () => PaywallScreen.show(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.workspace_premium, color: AppColors.premiumGold, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'YDS PRO\'ya Yükselt',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tüm denemeler ve 11 soru kategorisi açık. 7 gün ücretsiz dene!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ).animate().shimmer(duration: 1500.ms),
              const SizedBox(height: 20),
            ],

            // Exam Countdown & Target Score Card
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.alarm, color: AppColors.primaryLight, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          daysLeft > 0
                              ? '2026 YDS/2 Sınavına $daysLeft Gün Kaldı'
                              : 'Sınav Günü Geldi!',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Hedefin: $targetScore Puan (${_getLevelLetter(targetScore)})',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _showTargetDialog(context, ref, targetScore),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Hedefi Değiş', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            // Daily Target & Progress Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bugünkü Hedef',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${stats.totalSolved} / 25 Soru',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: (stats.totalSolved / 25).clamp(0.0, 1.0),
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    progressColor: AppColors.primaryLight,
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat(
                        title: 'Öğrenilen Kelime',
                        value: '${vocab.learnedCount}',
                        icon: Icons.check_circle_outline,
                        color: AppColors.success,
                      ),
                      _buildMiniStat(
                        title: 'Başarı Oranı',
                        value: '%${stats.accuracyPercentage.toStringAsFixed(0)}',
                        icon: Icons.trending_up,
                        color: AppColors.primaryLight,
                      ),
                      _buildMiniStat(
                        title: 'Kalan Kelime',
                        value: '${vocab.allWords.length - vocab.learnedCount}',
                        icon: Icons.hourglass_bottom,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DetailedStatsScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.insights, size: 16, color: AppColors.primaryLight),
                          SizedBox(width: 6),
                          Text(
                            'Detaylı Puan & Zayıf Halka Analizini Gör',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14, color: AppColors.primaryLight),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Quick Modules Grid (Kelimeler, Soru Bankası, Deneme Sınavı, Hata Defteri, Taktikler)
            const Text(
              'Çalışma Modülleri',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'Akıllı Kelime Kartları',
                    subtitle: '${vocab.allWords.length} YDS Kelimesi (SRS)',
                    icon: Icons.style,
                    gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    onTap: () => onTabChange(1), // Kelimeler tab
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: 'Soru Bankası',
                    subtitle: '11 Soru Kategorisi',
                    icon: Icons.quiz,
                    gradient: const [Color(0xFF10B981), Color(0xFF047857)],
                    onTap: () => onTabChange(2), // Soru Bankası tab
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'Akıllı Hata Defteri',
                    subtitle: '${questionState.mistakeQuestionIds.length} Hata • Telafi Testi',
                    icon: Icons.menu_book,
                    gradient: const [Color(0xFFDC2626), Color(0xFF991B1B)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MistakeNotebookScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: 'YDS Taktik Kartları',
                    subtitle: 'Edat, Tense & ÖSYM Sırları',
                    icon: Icons.lightbulb,
                    gradient: const [Color(0xFF6366F1), Color(0xFF4338CA)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const StrategyGuideScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'YDS Reading Atölyesi',
                    subtitle: 'Akademik Metin & Çeviri Analizi',
                    icon: Icons.auto_stories,
                    gradient: const [Color(0xFF0D9488), Color(0xFF0F766E)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ReadingHubScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: 'Hızlı Kelime Quizi',
                    subtitle: '4 Şıklı Pratik Testi',
                    icon: Icons.bolt,
                    gradient: const [Color(0xFFD97706), Color(0xFFB45309)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VocabQuizScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'Eş Anlamlı Eşleştirme',
                    subtitle: 'Synonym Mini Oyunu',
                    icon: Icons.extension,
                    gradient: const [Color(0xFFEA580C), Color(0xFFC2410C)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VocabMatchScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    title: 'Gerçek YDS Denemesi',
                    subtitle: '80 Soru • 180 Dk • Puanlama',
                    icon: Icons.timer,
                    gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    onTap: () => onTabChange(3), // Deneme tab
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Question Categories Preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'YDS Soru Tipleri',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => onTabChange(2),
                  child: const Text('Tümünü Gör'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildCategoryRow(
              category: QuestionCategory.vocabulary,
              title: 'Kelime Bilgisi (Vocabulary)',
              desc: 'Fiiller, Sıfatlar, İsimler & Phrasal Verbs',
              accuracy: stats.categoryAccuracy[QuestionCategory.vocabulary] ?? 0,
              onTap: () => onTabChange(2),
            ),
            _buildCategoryRow(
              category: QuestionCategory.grammar,
              title: 'Gramer & Dilbilgisi',
              desc: 'Bağlaçlar, Prepositions, Tense Uyumu',
              accuracy: stats.categoryAccuracy[QuestionCategory.grammar] ?? 0,
              onTap: () => onTabChange(2),
            ),
            _buildCategoryRow(
              category: QuestionCategory.reading,
              title: 'Paragraf & Okuma Parçaları',
              desc: 'Akademik metin analizi ve ana fikir soruları',
              accuracy: stats.categoryAccuracy[QuestionCategory.reading] ?? 0,
              onTap: () => onTabChange(2),
            ),
            _buildCategoryRow(
              category: QuestionCategory.translationEnTr,
              title: 'İngilizce - Türkçe Çeviri',
              desc: 'Özne-yüklem uyumu ve bağlaç takibi',
              accuracy: stats.categoryAccuracy[QuestionCategory.translationEnTr] ?? 0,
              onTap: () => onTabChange(2),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildMiniStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow({
    required QuestionCategory category,
    required String title,
    required String desc,
    required double accuracy,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bookmark_outline, color: AppColors.primaryLight, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showTargetDialog(BuildContext context, WidgetRef ref, int currentScore) {
    int tempScore = currentScore;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'YDS Hedef Puanını Belirle',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hedef puanına göre çalışma planın ve başarı oranın kişiselleştirilir.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Hedef Skor:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$tempScore Puan (${_getLevelLetter(tempScore)})',
                          style: const TextStyle(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: tempScore.toDouble(),
                    min: 50,
                    max: 100,
                    divisions: 10,
                    label: '$tempScore',
                    onChanged: (val) {
                      setSheetState(() => tempScore = val.round());
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(targetScoreProvider.notifier).setScore(tempScore);
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Hedefi Kaydet', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getLevelLetter(int score) {
    if (score >= 90) return 'A Seviyesi';
    if (score >= 80) return 'B Seviyesi';
    if (score >= 70) return 'C Seviyesi';
    if (score >= 60) return 'D Seviyesi';
    return 'E Seviyesi';
  }
}

