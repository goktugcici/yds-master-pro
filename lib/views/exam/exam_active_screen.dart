import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../providers/exam_provider.dart';
import 'exam_result_screen.dart';

class ExamActiveScreen extends ConsumerStatefulWidget {
  const ExamActiveScreen({super.key});

  @override
  ConsumerState<ExamActiveScreen> createState() => _ExamActiveScreenState();
}

class _ExamActiveScreenState extends ConsumerState<ExamActiveScreen> {
  Timer? _timer;
  int _questionSeconds = 0;
  int _lastQuestionIndex = -1;

  @override
  void initState() {
    super.initState();
    _startQuestionTimer();
  }

  void _startQuestionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _questionSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatQuestionSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final activeState = ref.watch(examStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (activeState == null) {
      return const Scaffold(
        body: Center(child: Text('Aktif sınav bulunamadı.')),
      );
    }

    final exam = activeState.exam;
    final question = activeState.currentQuestion;
    final totalQuestions = exam.questions.length;
    final currentIndex = activeState.currentQuestionIndex;

    // Reset question stopwatch if question index changed
    if (currentIndex != _lastQuestionIndex) {
      _lastQuestionIndex = currentIndex;
      _questionSeconds = 0;
    }

    // Pacing logic: 135 seconds is nominal target in YDS (80 Qs / 180 Min)
    final pacingProgress = (_questionSeconds / 135.0).clamp(0.0, 1.0);
    final isOvertime = _questionSeconds > 125;
    final isWarning = _questionSeconds >= 85 && _questionSeconds <= 125;

    Color pacingColor = AppColors.success;
    if (isOvertime) {
      pacingColor = AppColors.error;
    } else if (isWarning) {
      pacingColor = const Color(0xFFF59E0B);
    }

    return WillPopScope(
      onWillPop: () async {
        final shouldLeave = await _showExitConfirmation(context);
        return shouldLeave ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Soru ${currentIndex + 1} / $totalQuestions'),
          actions: [
            // Overall Exam Countdown Timer Badge
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: activeState.remainingSeconds < 300
                    ? AppColors.error.withValues(alpha: 0.15)
                    : AppColors.primaryLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.alarm,
                    size: 16,
                    color: activeState.remainingSeconds < 300
                        ? AppColors.error
                        : AppColors.primaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimer(activeState.remainingSeconds),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: activeState.remainingSeconds < 300
                          ? AppColors.error
                          : AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
            // Finish Button
            TextButton(
              onPressed: () => _confirmFinishExam(context, ref),
              child: const Text(
                'Bitir',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Soru Başına Akıllı Hız Asistanı (Pacing Meter)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.speed, size: 15, color: pacingColor),
                          const SizedBox(width: 5),
                          Text(
                            'Soru Süresi: ${_formatQuestionSeconds(_questionSeconds)}',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: pacingColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'ÖSYM Hedefi: ~2:15 dk/soru',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pacingProgress,
                      minHeight: 4,
                      backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(pacingColor),
                    ),
                  ),
                  if (isOvertime) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 12, color: AppColors.error),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Zaman Yönetimi: 2 dk aşıldı. Tıkandıysanız işaretleyip sonraya bırakabilirsiniz.',
                            style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Reading passage if present
                    if (question.passage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          question.passage!,
                          style: const TextStyle(fontSize: 13.5, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Question prompt
                    Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Options A, B, C, D, E
                    ...List.generate(question.options.length, (optIndex) {
                      final optionText = question.options[optIndex];
                      final isSelected =
                          activeState.currentSelectedAnswer == optIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(examStateProvider.notifier)
                                .selectAnswer(question.id, optIndex);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryLight.withValues(alpha: 0.12)
                                  : (isDark ? AppColors.cardDark : Colors.white),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryLight
                                    : (isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? AppColors.primaryLight
                                      : Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar with Question Sheet Trigger
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: currentIndex > 0
                        ? () => ref.read(examStateProvider.notifier).previousQuestion()
                        : null,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _showQuestionGridSheet(context, ref, activeState),
                    icon: const Icon(Icons.grid_view, size: 18),
                    label: const Text('Soru Haritası'),
                  ),
                  IconButton(
                    onPressed: currentIndex + 1 < totalQuestions
                        ? () => ref.read(examStateProvider.notifier).nextQuestion()
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestionGridSheet(
    BuildContext context,
    WidgetRef ref,
    ActiveExamState state,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        int activeTab = 0; // 0 = Soru Haritası, 1 = Optik Form

        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
            final liveState = ref.watch(examStateProvider) ?? state;
            final totalQ = liveState.exam.questions.length;
            final answeredQ = liveState.userAnswers.length;

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.78,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tab Switcher Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: const Text('Soru Haritası'),
                                selected: activeTab == 0,
                                onSelected: (_) => setSheetState(() => activeTab = 0),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text('ÖSYM Optik Form'),
                                selected: activeTab == 1,
                                onSelected: (_) => setSheetState(() => activeTab = 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$answeredQ / $totalQ',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // TAB 0: Question Grid Map
                  if (activeTab == 0) ...[
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(totalQ, (idx) {
                            final q = liveState.exam.questions[idx];
                            final isAnswered = liveState.userAnswers.containsKey(q.id);
                            final isCurrent = liveState.currentQuestionIndex == idx;

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(ctx).pop();
                                ref.read(examStateProvider.notifier).jumpToQuestion(idx);
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.primaryLight
                                      : (isAnswered
                                          ? AppColors.success.withValues(alpha: 0.2)
                                          : Colors.grey.withValues(alpha: 0.15)),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isCurrent
                                        ? AppColors.primary
                                        : (isAnswered ? AppColors.success : Colors.grey),
                                    width: isCurrent ? 2 : 1,
                                  ),
                                ),
                                child: Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent ? Colors.white : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],

                  // TAB 1: Authentic ÖSYM Optical Answer Sheet
                  if (activeTab == 1) ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white10 : const Color(0xFFFDE68A),
                          ),
                        ),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: totalQ,
                          separatorBuilder: (_, __) => const Divider(height: 12),
                          itemBuilder: (context, idx) {
                            final q = liveState.exam.questions[idx];
                            final selectedOpt = liveState.userAnswers[q.id];
                            final isCurrent = liveState.currentQuestionIndex == idx;

                            return Row(
                              children: [
                                // Question Number clickable jump
                                InkWell(
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    ref.read(examStateProvider.notifier).jumpToQuestion(idx);
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    width: 38,
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isCurrent
                                          ? AppColors.primaryLight.withValues(alpha: 0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${idx + 1}.',
                                      style: TextStyle(
                                        fontWeight: isCurrent ? FontWeight.w900 : FontWeight.bold,
                                        fontSize: 13.5,
                                        color: isCurrent ? AppColors.primaryLight : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Bubbles: A, B, C, D, E
                                ...List.generate(5, (optIdx) {
                                  final isBubbleMarked = selectedOpt == optIdx;

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(examStateProvider.notifier)
                                            .selectAnswer(q.id, optIdx);
                                        setSheetState(() {});
                                      },
                                      child: Container(
                                        height: 32,
                                        margin: const EdgeInsets.symmetric(horizontal: 3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isBubbleMarked
                                              ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF1E293B))
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isBubbleMarked
                                                ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF1E293B))
                                                : Colors.grey.withValues(alpha: 0.6),
                                            width: isBubbleMarked ? 2 : 1.2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          String.fromCharCode(65 + optIdx),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isBubbleMarked
                                                ? (isDark ? Colors.black : Colors.white)
                                                : (isDark ? Colors.white70 : Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sınavdan Çıkılsın mı?'),
        content: const Text(
          'Sınavdan çıkarsanız ilerlemeniz kaydedilmeyecektir. Emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Devam Et'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Çık'),
          ),
        ],
      ),
    );
  }

  void _confirmFinishExam(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sınavı Bitir'),
        content: const Text(
          'Sınavı sonlandırmak ve YDS puanınızı hesaplamak istiyor musunuz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final result =
                  await ref.read(examStateProvider.notifier).finishExam();
              if (context.mounted && result != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ExamResultScreen(result: result),
                  ),
                );
              }
            },
            child: const Text('Bitir ve Puanla'),
          ),
        ],
      ),
    );
  }
}
