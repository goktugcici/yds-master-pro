import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_words.dart';
import '../../models/word.dart';

class VocabMatchScreen extends StatefulWidget {
  const VocabMatchScreen({super.key});

  @override
  State<VocabMatchScreen> createState() => _VocabMatchScreenState();
}

class _VocabMatchScreenState extends State<VocabMatchScreen> {
  int _score = 0;
  int _round = 1;

  late List<Word> _roundWords;
  late List<String> _shuffledSynonyms;

  String? _selectedWord;
  String? _selectedSynonym;

  final Set<String> _matchedWords = {};

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startNewRound() {
    final eligible = defaultSeedWords.where((w) => w.synonyms.isNotEmpty).toList()..shuffle();
    _roundWords = eligible.take(4).toList();

    _shuffledSynonyms = _roundWords.map((w) => w.synonyms.first).toList()..shuffle();
    _selectedWord = null;
    _selectedSynonym = null;
    _matchedWords.clear();
  }

  void _checkMatch() {
    if (_selectedWord == null || _selectedSynonym == null) return;

    final targetWord = _roundWords.firstWhere((w) => w.english == _selectedWord);
    if (targetWord.synonyms.contains(_selectedSynonym)) {
      // Match found!
      setState(() {
        _matchedWords.add(_selectedWord!);
        _score += 20;
        _selectedWord = null;
        _selectedSynonym = null;
      });

      if (_matchedWords.length == _roundWords.length) {
        // Round completed
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _round++;
              _startNewRound();
            });
          }
        });
      }
    } else {
      // Wrong match
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            _selectedWord = null;
            _selectedSynonym = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eş Anlamlı Eşleştirme'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$_score Puan (Tur $_round)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kelimeyi ve eş anlamlısını seçerek eşleştirin:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Row(
                children: [
                  // Left column: English words
                  Expanded(
                    child: Column(
                      children: _roundWords.map((word) {
                        final isMatched = _matchedWords.contains(word.english);
                        final isSelected = _selectedWord == word.english;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: isMatched
                                ? null
                                : () {
                                    setState(() => _selectedWord = word.english);
                                    _checkMatch();
                                  },
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isMatched
                                    ? AppColors.success.withOpacity(0.12)
                                    : (isSelected
                                        ? AppColors.primaryLight.withOpacity(0.2)
                                        : (isDark ? AppColors.cardDark : Colors.white)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isMatched
                                      ? AppColors.success
                                      : (isSelected
                                          ? AppColors.primaryLight
                                          : (isDark ? AppColors.borderDark : AppColors.borderLight)),
                                  width: isSelected || isMatched ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  word.english,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isMatched ? AppColors.success : null,
                                    decoration: isMatched ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right column: Synonyms
                  Expanded(
                    child: Column(
                      children: _shuffledSynonyms.map((syn) {
                        // Check if this synonym belongs to an already matched word
                        final isMatched = _roundWords.any(
                          (w) => _matchedWords.contains(w.english) && w.synonyms.contains(syn),
                        );
                        final isSelected = _selectedSynonym == syn;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: isMatched
                                ? null
                                : () {
                                    setState(() => _selectedSynonym = syn);
                                    _checkMatch();
                                  },
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isMatched
                                    ? AppColors.success.withOpacity(0.12)
                                    : (isSelected
                                        ? AppColors.primaryLight.withOpacity(0.2)
                                        : (isDark ? AppColors.cardDark : Colors.white)),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isMatched
                                      ? AppColors.success
                                      : (isSelected
                                          ? AppColors.primaryLight
                                          : (isDark ? AppColors.borderDark : AppColors.borderLight)),
                                  width: isSelected || isMatched ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  syn,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isMatched ? AppColors.success : null,
                                    decoration: isMatched ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
