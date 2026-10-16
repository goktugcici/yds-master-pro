import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_collocations.dart';
import '../../models/collocation.dart';

class CollocationQuizScreen extends StatefulWidget {
  const CollocationQuizScreen({super.key});

  @override
  State<CollocationQuizScreen> createState() => _CollocationQuizScreenState();
}

class _CollocationQuizScreenState extends State<CollocationQuizScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Library State
  String _searchQuery = '';
  String _selectedPrepositionFilter = 'all';

  // Quiz State
  late List<Collocation> _quizPool;
  int _currentQuizIndex = 0;
  int? _selectedOptionIndex;
  bool _hasSubmitted = false;
  int _scoreCorrect = 0;
  int _scoreTotal = 0;
  late List<String> _currentOptions;

  final List<String> _prepositionFilters = [
    'all',
    'to',
    'on',
    'from',
    'of',
    'with',
    'in',
    'for',
    'about',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initQuiz();
  }

  void _initQuiz() {
    _quizPool = List.from(defaultCollocations)..shuffle(Random());
    _currentQuizIndex = 0;
    _scoreCorrect = 0;
    _scoreTotal = 0;
    _generateOptionsForCurrent();
  }

  void _generateOptionsForCurrent() {
    if (_quizPool.isEmpty) return;
    final current = _quizPool[_currentQuizIndex % _quizPool.length];
    final correctPrep = current.preposition;

    // Pick 3 random distractor prepositions
    final distractors = _prepositionFilters
        .where((p) => p != 'all' && p != correctPrep)
        .toList()
      ..shuffle();

    _currentOptions = [correctPrep, ...distractors.take(3)]..shuffle();
    _selectedOptionIndex = null;
    _hasSubmitted = false;
  }

  void _submitAnswer(int optionIndex) {
    if (_hasSubmitted) return;

    final current = _quizPool[_currentQuizIndex % _quizPool.length];
    final selectedPrep = _currentOptions[optionIndex];
    final isCorrect = selectedPrep == current.preposition;

    setState(() {
      _selectedOptionIndex = optionIndex;
      _hasSubmitted = true;
      _scoreTotal++;
      if (isCorrect) _scoreCorrect++;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuizIndex = (_currentQuizIndex + 1) % _quizPool.length;
      _generateOptionsForCurrent();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Edat & Kolokasyon Laboratuvarı'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryLight,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'Kütüphane'),
            Tab(icon: Icon(Icons.bolt), text: 'Edat Quizi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Collocations Library
          _buildLibraryTab(context, isDark),

          // TAB 2: Interactive Preposition Quiz
          _buildQuizTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildLibraryTab(BuildContext context, bool isDark) {
    final filtered = defaultCollocations.where((c) {
      if (_selectedPrepositionFilter != 'all' &&
          c.preposition != _selectedPrepositionFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return c.word.toLowerCase().contains(q) ||
            c.preposition.toLowerCase().contains(q) ||
            c.meaningTr.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Search & Filters Header
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? AppColors.cardDark : Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Fiil, sıfat veya edat ara (örn: rely, to, from)...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  isDense: true,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _prepositionFilters.map((prep) {
                    final isSelected = _selectedPrepositionFilter == prep;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(prep == 'all' ? 'Tümü' : prep),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        selectedColor: AppColors.primaryLight,
                        checkmarkColor: Colors.white,
                        onSelected: (val) {
                          setState(() => _selectedPrepositionFilter = prep);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // List of Collocations
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'Eşleşen edat / kolokasyon bulunamadı.',
                    style: TextStyle(
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.word,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.preposition,
                                      style: const TextStyle(
                                        color: AppColors.primaryLight,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.partOfSpeech.toUpperCase(),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.meaningTr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '"${item.exampleSentence}"',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12.5,
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lightbulb_outline, size: 14, color: AppColors.warning),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.tip,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildQuizTab(BuildContext context, bool isDark) {
    if (_quizPool.isEmpty) {
      return const Center(child: Text('Soru havuzu boş.'));
    }

    final current = _quizPool[_currentQuizIndex % _quizPool.length];
    // Replace the preposition in the example sentence with [ ____ ]
    final maskedSentence = current.exampleSentence.replaceAll(
      RegExp('\\b${RegExp.escape(current.preposition)}\\b', caseSensitive: false),
      ' [ ___ ] ',
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Score & Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soru ${_currentQuizIndex + 1} / ${_quizPool.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Başarı: $_scoreCorrect / $_scoreTotal',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Question Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Hedef Sözcük: ${current.word}',
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      current.meaningTr,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cümledeki boşluğa hangi edat (preposition) gelmelidir?',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  maskedSentence,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Options Grid (2x2)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_currentOptions.length, (index) {
              final prep = _currentOptions[index];
              final isSelected = _selectedOptionIndex == index;
              final isCorrect = prep == current.preposition;

              Color border = isDark ? AppColors.borderDark : AppColors.borderLight;
              Color bg = isDark ? AppColors.cardDark : Colors.white;
              Color textColor = isDark ? Colors.white : Colors.black87;

              if (_hasSubmitted) {
                if (isCorrect) {
                  border = AppColors.success;
                  bg = AppColors.success.withOpacity(0.12);
                  textColor = AppColors.success;
                } else if (isSelected) {
                  border = AppColors.error;
                  bg = AppColors.error.withOpacity(0.12);
                  textColor = AppColors.error;
                }
              }

              return SizedBox(
                width: (MediaQuery.of(context).size.width - 52) / 2,
                child: InkWell(
                  onTap: _hasSubmitted ? null : () => _submitAnswer(index),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border, width: isSelected || (_hasSubmitted && isCorrect) ? 2 : 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      prep,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // Explanation Box & Next Button
          if (_hasSubmitted) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _currentOptions[_selectedOptionIndex!] == current.preposition
                      ? AppColors.success
                      : AppColors.error,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _currentOptions[_selectedOptionIndex!] == current.preposition
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _currentOptions[_selectedOptionIndex!] == current.preposition
                            ? AppColors.success
                            : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Doğru Kalıp: ${current.fullPhrase}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anlamı: ${current.meaningTr}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'ÖSYM İpucu: ${current.tip}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _nextQuestion,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Sonraki Soruya Geç'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
