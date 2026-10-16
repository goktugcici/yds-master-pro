import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_phrasal_verbs.dart';
import '../../models/phrasal_verb.dart';

class PhrasalVerbsScreen extends StatefulWidget {
  const PhrasalVerbsScreen({super.key});

  @override
  State<PhrasalVerbsScreen> createState() => _PhrasalVerbsScreenState();
}

class _PhrasalVerbsScreenState extends State<PhrasalVerbsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedParticle = 'Tümü';
  String _searchQuery = '';

  // Quiz State
  int _currentQuizIndex = 0;
  int? _selectedQuizOption;
  bool _isAnswerSubmitted = false;
  int _quizScore = 0;
  late List<PhrasalVerb> _quizPool;
  late List<List<String>> _quizOptions;

  final List<String> _particleCategories = [
    'Tümü',
    'out',
    'for',
    'about',
    'off',
    'with',
    'into',
    'from',
    'to',
    'on',
    'down',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initQuiz();
  }

  void _initQuiz() {
    _quizPool = List.from(defaultPhrasalVerbs)..shuffle(Random());
    _currentQuizIndex = 0;
    _selectedQuizOption = null;
    _isAnswerSubmitted = false;
    _quizScore = 0;
    _generateQuizOptions();
  }

  void _generateQuizOptions() {
    final random = Random();
    _quizOptions = [];

    for (int i = 0; i < _quizPool.length; i++) {
      final current = _quizPool[i];
      final distractors = defaultPhrasalVerbs
          .where((pv) => pv.id != current.id)
          .map((pv) => pv.fullPhrase)
          .toList()
        ..shuffle(random);

      final options = [current.fullPhrase, ...distractors.take(3)]..shuffle(random);
      _quizOptions.add(options);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PhrasalVerb> get _filteredPhrasalVerbs {
    return defaultPhrasalVerbs.where((pv) {
      if (_selectedParticle != 'Tümü') {
        if (!pv.particles.toLowerCase().contains(_selectedParticle.toLowerCase())) {
          return false;
        }
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesPhrase = pv.fullPhrase.toLowerCase().contains(q);
        final matchesTr = pv.turkish.toLowerCase().contains(q);
        final matchesSyn = pv.synonyms.any((s) => s.toLowerCase().contains(q));
        if (!matchesPhrase && !matchesTr && !matchesSyn) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Phrasal Verbs Atölyesi'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryLight,
          indicatorWeight: 3,
          labelColor: isDark ? Colors.white : AppColors.primaryLight,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'Deyimsel Fiiller'),
            Tab(icon: Icon(Icons.psychology), text: 'Phrasal Verb Quizi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLibraryTab(isDark),
          _buildQuizTab(isDark),
        ],
      ),
    );
  }

  Widget _buildLibraryTab(bool isDark) {
    final list = _filteredPhrasalVerbs;

    return Column(
      children: [
        // Search & Filter Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: isDark ? AppColors.surfaceDark : Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Fiil, edat veya Türkçe anlam ara...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Particle Filter Chips
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _particleCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final p = _particleCategories[index];
                    final isSelected = _selectedParticle == p;

                    return FilterChip(
                      label: Text(p),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedParticle = p);
                      },
                      selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.primaryLight,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primaryLight
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // List View
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 56, color: Colors.grey.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      const Text('Aradığınız kriterlere uygun deyimsel fiil bulunamadı.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final pv = list[index];
                    return _buildPhrasalVerbCard(pv, isDark);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPhrasalVerbCard(PhrasalVerb pv, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Full Phrase + Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pv.fullPhrase,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pv.level,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Turkish Meaning
          Text(
            pv.turkish,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
            ),
          ),

          const SizedBox(height: 4),

          // Academic Definition
          Text(
            pv.academicMeaning,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          // Synonyms Row
          if (pv.synonyms.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: pv.synonyms.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Example Sentence & Translation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote, size: 16, color: AppColors.primaryLight),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pv.exampleSentence,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    pv.exampleTranslation,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ÖSYM Sınav Tuzağı
          if (pv.osymTrapWarning.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 16, color: Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ÖSYM İpucu: ${pv.osymTrapWarning}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF92400E),
                      ),
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

  Widget _buildQuizTab(bool isDark) {
    if (_currentQuizIndex >= _quizPool.length) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 72, color: Color(0xFFF59E0B)),
              const SizedBox(height: 16),
              const Text(
                'Tebrikler! Quizi Tamamladınız',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Toplam Skor: $_quizScore / ${_quizPool.length}',
                style: const TextStyle(fontSize: 17, color: AppColors.primaryLight),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => setState(_initQuiz),
                icon: const Icon(Icons.replay),
                label: const Text('Yeniden Başla'),
              ),
            ],
          ),
        ),
      );
    }

    final currentPv = _quizPool[_currentQuizIndex];
    final options = _quizOptions[_currentQuizIndex];

    // Build sentence with masked phrasal verb
    final regex = RegExp(
      RegExp.escape(currentPv.verb),
      caseSensitive: false,
    );
    final maskedSentence = currentPv.exampleSentence.replaceAll(
      RegExp(r'\b(' + RegExp.escape(currentPv.verb) + r'(\w*))' + r'(\s+' + RegExp.escape(currentPv.particles) + r')?', caseSensitive: false),
      '[ ______ ]',
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soru ${_currentQuizIndex + 1} / ${_quizPool.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Doğru: $_quizScore',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Question Card
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
                const Text(
                  'Cümledeki boşluğa hangi deyimsel fiil (phrasal verb) gelmelidir?',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  maskedSentence,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '💡 İpucu Türkçe Anlam: "${currentPv.turkish}"',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Options List
          ...List.generate(options.length, (optIdx) {
            final opt = options[optIdx];
            final isSelected = _selectedQuizOption == optIdx;
            final isCorrect = opt == currentPv.fullPhrase;

            Color bg = isDark ? AppColors.cardDark : Colors.white;
            Color border = isDark ? AppColors.borderDark : AppColors.borderLight;
            Color textCol = isDark ? Colors.white : AppColors.textLightPrimary;

            if (_isAnswerSubmitted) {
              if (isCorrect) {
                bg = AppColors.success.withValues(alpha: 0.15);
                border = AppColors.success;
                textCol = AppColors.success;
              } else if (isSelected && !isCorrect) {
                bg = AppColors.error.withValues(alpha: 0.15);
                border = AppColors.error;
                textCol = AppColors.error;
              }
            } else if (isSelected) {
              bg = AppColors.primaryLight.withValues(alpha: 0.12);
              border = AppColors.primaryLight;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: _isAnswerSubmitted
                    ? null
                    : () {
                        setState(() {
                          _selectedQuizOption = optIdx;
                          _isAnswerSubmitted = true;
                          if (isCorrect) _quizScore++;
                        });
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border, width: isSelected ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        String.fromCharCode(65 + optIdx) + ')',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textCol,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Solution Explanation
          if (_isAnswerSubmitted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedQuizOption != null &&
                        options[_selectedQuizOption!] == currentPv.fullPhrase
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedQuizOption != null &&
                          options[_selectedQuizOption!] == currentPv.fullPhrase
                      ? const Color(0xFFBBF7D0)
                      : const Color(0xFFFECACA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doğru Kalıp: ${currentPv.fullPhrase} (${currentPv.turkish})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Akademik Anlam: ${currentPv.academicMeaning}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Çeviri: "${currentPv.exampleTranslation}"',
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentQuizIndex++;
                  _selectedQuizOption = null;
                  _isAnswerSubmitted = false;
                });
              },
              child: const Text('Sonraki Soruya Geç'),
            ),
          ],
        ],
      ),
    );
  }
}
