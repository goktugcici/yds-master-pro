import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_words.dart';
import '../../models/word.dart';

class VocabQuizScreen extends ConsumerStatefulWidget {
  const VocabQuizScreen({super.key});

  @override
  ConsumerState<VocabQuizScreen> createState() => _VocabQuizScreenState();
}

class _VocabQuizScreenState extends ConsumerState<VocabQuizScreen> {
  int _score = 0;
  int _questionIndex = 0;
  int? _selectedOptionIndex;
  bool _answered = false;

  late List<Word> _quizWords;
  late Word _currentWord;
  late List<String> _currentOptions;
  late int _correctOptionIndex;

  @override
  void initState() {
    super.initState();
    _quizWords = List<Word>.from(defaultSeedWords)..shuffle();
    _setupQuestion();
  }

  void _setupQuestion() {
    if (_quizWords.isEmpty) return;
    _currentWord = _quizWords[_questionIndex % _quizWords.length];

    // Generate 3 random wrong options from other words
    final random = Random();
    final otherWords = defaultSeedWords.where((w) => w.id != _currentWord.id).toList()..shuffle();
    final wrongOptions = otherWords.take(3).map((w) => w.turkish).toList();

    _currentOptions = [
      _currentWord.turkish,
      ...wrongOptions,
    ]..shuffle(random);

    _correctOptionIndex = _currentOptions.indexOf(_currentWord.turkish);
    _selectedOptionIndex = null;
    _answered = false;
  }

  void _handleOptionSelect(int index) {
    if (_answered) return;

    setState(() {
      _selectedOptionIndex = index;
      _answered = true;
      if (index == _correctOptionIndex) {
        _score += 10;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _questionIndex++;
          _setupQuestion();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hızlı Kelime Quizi'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: AppColors.primaryLight, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$_score Puan',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Soru ${_questionIndex + 1}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Prompt Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
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
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _currentWord.english,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentWord.partOfSpeech.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Kelimenin Türkçe karşılığını seçin:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 14),

            // 4 Options
            ...List.generate(_currentOptions.length, (idx) {
              final optionText = _currentOptions[idx];
              final isSelected = _selectedOptionIndex == idx;
              final isCorrect = idx == _correctOptionIndex;

              Color bg = isDark ? AppColors.cardDark : Colors.white;
              Color border = isDark ? AppColors.borderDark : AppColors.borderLight;
              Color textCol = isDark ? Colors.white : AppColors.textLightPrimary;

              if (_answered) {
                if (isCorrect) {
                  bg = AppColors.success.withOpacity(0.15);
                  border = AppColors.success;
                  textCol = AppColors.success;
                } else if (isSelected && !isCorrect) {
                  bg = AppColors.error.withOpacity(0.15);
                  border = AppColors.error;
                  textCol = AppColors.error;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _handleOptionSelect(idx),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border, width: isSelected ? 2 : 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            optionText,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: textCol,
                            ),
                          ),
                        ),
                        if (_answered && isCorrect)
                          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                        if (_answered && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: AppColors.error, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
