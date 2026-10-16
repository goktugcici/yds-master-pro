import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../models/question.dart';
import '../../providers/exam_provider.dart';
import '../../providers/question_provider.dart';
import '../../providers/subscription_provider.dart';
import '../paywall/paywall_screen.dart';
import 'exam_active_screen.dart';

class ExamListScreen extends ConsumerStatefulWidget {
  const ExamListScreen({super.key});

  @override
  ConsumerState<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends ConsumerState<ExamListScreen> {
  String _selectedTab = 'all'; // 'all', 'full', 'branch'

  @override
  Widget build(BuildContext context) {
    final sub = ref.watch(subscriptionProvider);
    final history = ref.watch(examHistoryProvider);
    final exams = ref.watch(availableExamsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredExams = exams.where((exam) {
      if (_selectedTab == 'full') {
        return !exam.id.contains('branch');
      }
      if (_selectedTab == 'branch') {
        return exam.id.contains('branch');
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Deneme Sınavları'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCustomExamWizard(context),
        icon: const Icon(Icons.tune),
        label: const Text('Özel Sınav Oluştur'),
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
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
                        'Tam simülasyonlar, branş testleri ve kişiselleştirilmiş deneme sihirbazı.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Custom Exam Wizard Card
          InkWell(
            onTap: () => _showCustomExamWizard(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryLight.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.primaryLight, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kendi Denemeni Oluştur (Sihirbaz)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Soru sayısını, süreyi ve dilediğin kategorileri sen belirle!',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryLight),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Category Filter Chips (Tümü / Tam Denemeler / Branş Denemeleri)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tüm Denemeler (${exams.length})', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Genel Denemeler (80 & 20 Soru)', 'full'),
                const SizedBox(width: 8),
                _buildFilterChip('Branş Denemeleri', 'branch'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Exam Cards List
          ...filteredExams.map((exam) {
            final isLocked = exam.isPremiumOnly && !sub.isPro;
            final isBranch = exam.id.contains('branch');

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
                            color: (isBranch ? const Color(0xFF0D9488) : AppColors.primaryLight)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${exam.durationMinutes} Dakika',
                            style: TextStyle(
                              color: isBranch ? const Color(0xFF0D9488) : AppColors.primaryLight,
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
                            _startExam(context, exam);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isLocked ? AppColors.premiumGold : AppColors.primaryLight,
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
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String tabKey) {
    final isSelected = _selectedTab == tabKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedTab = tabKey;
        });
      },
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12.5,
      ),
    );
  }

  void _startExam(BuildContext context, Exam exam) {
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

  void _showCustomExamWizard(BuildContext context) {
    int selectedQuestionCount = 20;
    int selectedDurationMinutes = 45;
    String selectedDifficulty = 'Tümü';
    Set<QuestionCategory> selectedCategories = Set.from(QuestionCategory.values);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (modalCtx, setModalState) {
          final isDark = Theme.of(modalCtx).brightness == Brightness.dark;

          return Container(
            height: MediaQuery.of(modalCtx).size.height * 0.82,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: AppColors.primaryLight),
                    SizedBox(width: 8),
                    Text(
                      'Özel Deneme Sihirbazı',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hedefine göre soru sayısını, süreyi ve soru kategorilerini özelleştir.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // Question Count
                      const Text(
                        'Soru Sayısı',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [10, 20, 40, 80].map((count) {
                          final isSel = selectedQuestionCount == count;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedQuestionCount = count;
                                    selectedDurationMinutes = (count * 2.25).toInt();
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSel
                                      ? AppColors.primaryLight.withOpacity(0.15)
                                      : Colors.transparent,
                                  side: BorderSide(
                                    color: isSel ? AppColors.primaryLight : Colors.grey.shade400,
                                    width: isSel ? 2 : 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  '$count Soru',
                                  style: TextStyle(
                                    color: isSel ? AppColors.primaryLight : null,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Duration
                      const Text(
                        'Sınav Süresi (Dakika)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [15, 30, 45, 90, 180].map((dur) {
                          final isSel = selectedDurationMinutes == dur;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedDurationMinutes = dur;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSel
                                      ? AppColors.primaryLight.withOpacity(0.15)
                                      : Colors.transparent,
                                  side: BorderSide(
                                    color: isSel ? AppColors.primaryLight : Colors.grey.shade400,
                                    width: isSel ? 2 : 1,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  '$dur Dk',
                                  style: TextStyle(
                                    color: isSel ? AppColors.primaryLight : null,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Difficulty
                      const Text(
                        'Zorluk Seviyesi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Tümü', 'Kolay', 'Orta', 'İleri'].map((diff) {
                          final isSel = selectedDifficulty == diff;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: OutlinedButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedDifficulty = diff;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSel
                                      ? AppColors.primaryLight.withOpacity(0.15)
                                      : Colors.transparent,
                                  side: BorderSide(
                                    color: isSel ? AppColors.primaryLight : Colors.grey.shade400,
                                    width: isSel ? 2 : 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  diff,
                                  style: TextStyle(
                                    color: isSel ? AppColors.primaryLight : null,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kategoriler',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedCategories = Set.from(QuestionCategory.values);
                                  });
                                },
                                child: const Text('Tümünü Seç', style: TextStyle(fontSize: 12)),
                              ),
                              TextButton(
                                onPressed: () {
                                  setModalState(() {
                                    selectedCategories.clear();
                                  });
                                },
                                child: const Text('Temizle', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: QuestionCategory.values.map((cat) {
                          final isSel = selectedCategories.contains(cat);
                          return FilterChip(
                            label: Text(cat.titleTr),
                            selected: isSel,
                            onSelected: (val) {
                              setModalState(() {
                                if (val) {
                                  selectedCategories.add(cat);
                                } else {
                                  if (selectedCategories.length > 1) {
                                    selectedCategories.remove(cat);
                                  }
                                }
                              });
                            },
                            selectedColor: AppColors.primaryLight.withOpacity(0.2),
                            checkmarkColor: AppColors.primaryLight,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: isSel ? AppColors.primaryLight : null,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Launch Custom Exam Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedCategories.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lütfen en az bir kategori seçin.')),
                        );
                        return;
                      }

                      final pool = ref.read(questionNotifierProvider).allQuestions;
                      final customExam = ExamNotifier.createCustomExam(
                        title: 'Özel YDS Denemesi ($selectedQuestionCount Soru)',
                        questionCount: selectedQuestionCount,
                        durationMinutes: selectedDurationMinutes,
                        categories: selectedCategories.toList(),
                        pool: pool,
                        difficulty: selectedDifficulty,
                        isPremiumOnly: false,
                      );

                      Navigator.of(modalCtx).pop();
                      ref.read(examStateProvider.notifier).startExam(customExam);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ExamActiveScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      '$selectedQuestionCount Soruluk Özel Denemeyi Başlat',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
