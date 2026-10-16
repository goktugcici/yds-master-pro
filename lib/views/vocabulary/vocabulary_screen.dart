import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/word.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/vocabulary_provider.dart';
import 'vocab_match_screen.dart';
import 'vocab_quiz_screen.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isCardFlipped = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _isCardFlipped = !_isCardFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vocab = ref.watch(vocabularyProvider);
    final sub = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final words = vocab.filteredWords;
    final currentWord = words.isNotEmpty && vocab.currentCardIndex < words.length
        ? words[vocab.currentCardIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Kelime & Hafıza'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt, color: AppColors.warning),
            tooltip: 'Hızlı Kelime Quizi',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VocabQuizScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.extension, color: AppColors.primaryLight),
            tooltip: 'Eş Anlamlı Eşleştirme',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VocabMatchScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryLight,
          tabs: const [
            Tab(icon: Icon(Icons.style), text: 'Flashcard / Kartlar'),
            Tab(icon: Icon(Icons.list_alt), text: 'Kelime Listesi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Flashcard & Spaced Repetition Mode
          _buildFlashcardTab(context, vocab, currentWord, isDark, sub.isPro),

          // TAB 2: Searchable Word List
          _buildWordListTab(context, vocab, words, isDark),
        ],
      ),
    );
  }

  Widget _buildFlashcardTab(
    BuildContext context,
    VocabularyState vocab,
    Word? currentWord,
    bool isDark,
    bool isPro,
  ) {
    final totalCards = vocab.filteredWords.length;

    if (totalCards == 0 || currentWord == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Bu filtrede henüz kelime bulunamadı.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(vocabularyProvider.notifier).setCategory('all');
                ref.read(vocabularyProvider.notifier).setFilter('all');
              },
              child: const Text('Filtreleri Sıfırla'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Category selector chips
          _buildCategoryFilterChips(vocab),
          const SizedBox(height: 16),

          // Progress indicator & Favorite icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kart: ${vocab.currentCardIndex + 1} / $totalCards',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              IconButton(
                icon: Icon(
                  currentWord.isFavorite ? Icons.star : Icons.star_border,
                  color: currentWord.isFavorite ? AppColors.premiumGold : Colors.grey,
                  size: 28,
                ),
                onPressed: () {
                  ref.read(vocabularyProvider.notifier).toggleFavorite(currentWord.id);
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Flip Flashcard Widget
          GestureDetector(
            onTap: _flipCard,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (widget, animation) {
                final rotate = Tween(begin: pi, end: 0.0).animate(animation);
                return AnimatedBuilder(
                  animation: rotate,
                  builder: (context, child) {
                    final isUnder = (ValueKey(_isCardFlipped) != widget.key);
                    var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                    tilt *= isUnder ? -1.0 : 1.0;
                    final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
                    return Transform(
                      transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                      alignment: Alignment.center,
                      child: widget,
                    );
                  },
                  child: widget,
                );
              },
              child: _isCardFlipped
                  ? _buildCardBack(currentWord, isDark, key: const ValueKey(true))
                  : _buildCardFront(currentWord, isDark, key: const ValueKey(false)),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons: Tekrar Et (SRS -) vs Biliyorum (SRS +)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    setState(() => _isCardFlipped = false);
                    ref.read(vocabularyProvider.notifier).answerUnknown(currentWord.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.replay, size: 20),
                      SizedBox(width: 8),
                      Text('Tekrar Et', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    setState(() => _isCardFlipped = false);
                    ref.read(vocabularyProvider.notifier).answerKnown(currentWord.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check, size: 20),
                      SizedBox(width: 8),
                      Text('Biliyorum', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Next / Prev nav
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() => _isCardFlipped = false);
                  ref.read(vocabularyProvider.notifier).previousCard();
                },
              ),
              const SizedBox(width: 24),
              const Text('Kartı Çevirmek İçin Dokun 👆', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() => _isCardFlipped = false);
                  ref.read(vocabularyProvider.notifier).nextCard();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(Word word, bool isDark, {required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Level & Part of Speech Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word.level,
                  style: const TextStyle(
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word.partOfSpeech.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // English Word
          Text(
            word.english,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 24),

          // Hint / Tap to reveal prompt
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.touch_app, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Anlamını ve YDS cümlesini gör',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Word word, bool isDark, {required Key key}) {
    return Container(
      key: key,
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162038) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.success.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turkish Translation Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word.turkish,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const Icon(Icons.check_circle_outline, color: AppColors.success),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(),
          const SizedBox(height: 10),

          // Synonyms (Eş Anlamlılar)
          if (word.synonyms.isNotEmpty) ...[
            const Text(
              'Eş Anlamlılar (Synonyms):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: word.synonyms.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ],

          // Example Sentence (Örnek YDS Cümlesi)
          const Text(
            'Örnek YDS Cümlesi:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          Text(
            '"${word.exampleSentence}"',
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            word.exampleTranslation,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterChips(VocabularyState vocab) {
    final categories = [
      {'id': 'all', 'label': 'Tümü'},
      {'id': 'verb', 'label': 'Fiiller'},
      {'id': 'noun', 'label': 'İsimler'},
      {'id': 'adj', 'label': 'Sıfatlar'},
      {'id': 'phrasal_verb', 'label': 'Phrasal Verbs'},
      {'id': 'collocation', 'label': 'Kalıplar'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = vocab.selectedCategory == cat['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat['label']!),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _isCardFlipped = false);
                ref.read(vocabularyProvider.notifier).setCategory(cat['id']!);
              },
              selectedColor: AppColors.primaryLight.withOpacity(0.2),
              checkmarkColor: AppColors.primaryLight,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWordListTab(
    BuildContext context,
    VocabularyState vocab,
    List<Word> words,
    bool isDark,
  ) {
    return Column(
      children: [
        // Search Input
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Kelime ara (İngilizce veya Türkçe)...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(vocabularyProvider.notifier).setSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: isDark ? AppColors.cardDark : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            onChanged: (val) {
              ref.read(vocabularyProvider.notifier).setSearchQuery(val);
            },
          ),
        ),

        // Word Items List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: words.length,
            separatorBuilder: (_, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final w = words[index];
              return Container(
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: w.isLearned
                            ? AppColors.success.withOpacity(0.15)
                            : AppColors.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        w.isLearned ? Icons.check_circle : Icons.school,
                        color: w.isLearned ? AppColors.success : AppColors.primaryLight,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w.english,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            w.turkish,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        w.isFavorite ? Icons.star : Icons.star_border,
                        color: w.isFavorite ? AppColors.premiumGold : Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(vocabularyProvider.notifier).toggleFavorite(w.id);
                      },
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
}
