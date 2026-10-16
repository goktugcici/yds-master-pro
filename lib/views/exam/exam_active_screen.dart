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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Soru Haritası',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(state.exam.questions.length, (idx) {
                  final q = state.exam.questions[idx];
                  final isAnswered = state.userAnswers.containsKey(q.id);
                  final isCurrent = state.currentQuestionIndex == idx;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      ref.read(examStateProvider.notifier).jumpToQuestion(idx);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColors.primaryLight
                            : (isAnswered
                                ? AppColors.success.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.15)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent
                              ? AppColors.primary
                              : (isAnswered ? AppColors.success : Colors.grey),
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
            ],
          ),
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
