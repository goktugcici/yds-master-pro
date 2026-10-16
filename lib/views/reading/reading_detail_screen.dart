import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/reading_article.dart';
import '../../providers/vocabulary_provider.dart';

class ReadingDetailScreen extends ConsumerStatefulWidget {
  final ReadingArticle article;

  const ReadingDetailScreen({super.key, required this.article});

  @override
  ConsumerState<ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends ConsumerState<ReadingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, int> _selectedAnswers = {};
  final Set<int> _submittedQuestions = {};

  Timer? _readingTimer;
  int _elapsedSeconds = 0;
  bool _isTiming = false;
  int? _calculatedWpm;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _readingTimer?.cancel();
    setState(() {
      _isTiming = true;
      _elapsedSeconds = 0;
      _calculatedWpm = null;
    });
    _readingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  void _stopTimer() {
    _readingTimer?.cancel();
    final wordCount = widget.article.contentEn.trim().split(RegExp(r'\s+')).length;
    final sec = _elapsedSeconds > 0 ? _elapsedSeconds : 1;
    final wpm = ((wordCount / sec) * 60).round();
    setState(() {
      _isTiming = false;
      _calculatedWpm = wpm;
    });
  }

  void _resetTimer() {
    _readingTimer?.cancel();
    setState(() {
      _isTiming = false;
      _elapsedSeconds = 0;
      _calculatedWpm = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryLight,
          tabs: const [
            Tab(icon: Icon(Icons.article), text: 'Metin & Analiz'),
            Tab(icon: Icon(Icons.style), text: 'Kritik Kelimeler'),
            Tab(icon: Icon(Icons.quiz), text: 'Sorular'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: English & Turkish Reader
          _buildReaderTab(context, article, isDark),

          // TAB 2: Vocabulary Highlights
          _buildVocabularyTab(context, article, isDark),

          // TAB 3: Comprehension Questions
          _buildQuestionsTab(context, article, isDark),
        ],
      ),
    );
  }

  Widget _buildReaderTab(
    BuildContext context,
    ReadingArticle article,
    bool isDark,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meta tags
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  article.topic,
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
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Seviye: ${article.level}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${article.readTimeMinutes} dk',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Title
          Text(
            article.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.3),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Speed Reading & WPM Timer Card
          _buildSpeedReadingCard(context, isDark, article),

          const SizedBox(height: 16),

          // English content
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
                  children: const [
                    Icon(Icons.language, size: 18, color: AppColors.primaryLight),
                    SizedBox(width: 8),
                    Text(
                      'İNGİLİZCE ORİJİNAL METİN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  article.contentEn,
                  style: const TextStyle(fontSize: 15, height: 1.6),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Turkish translation accordion / container
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: false,
                leading: const Icon(Icons.translate, color: AppColors.success),
                title: const Text(
                  'Türkçe Çeviriyi Göster',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                children: [
                  Text(
                    article.contentTr,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSpeedReadingCard(BuildContext context, bool isDark, ReadingArticle article) {
    final wordCount = article.contentEn.trim().split(RegExp(r'\s+')).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isTiming
              ? AppColors.primaryLight
              : (_calculatedWpm != null
                  ? AppColors.success
                  : (isDark ? AppColors.borderDark : AppColors.borderLight)),
          width: _isTiming || _calculatedWpm != null ? 1.5 : 1.0,
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.speed, color: AppColors.primaryLight, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YDS Okuma Hızı & WPM Kronometresi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      Text(
                        '$wordCount Kelime • Hedef: 180 - 220 WPM',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isTiming)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.red, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${(_elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (!_isTiming && _calculatedWpm == null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startTimer,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Okumayı Başlat (Süre Ölç)', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ] else if (_isTiming) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _stopTimer,
                icon: const Icon(Icons.flag, size: 18),
                label: const Text('Metni Bitirdim • Hızımı Hesapla', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ] else if (_calculatedWpm != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getWpmColor(_calculatedWpm!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getWpmColor(_calculatedWpm!).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_calculatedWpm WPM',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: _getWpmColor(_calculatedWpm!),
                        ),
                      ),
                      Text(
                        '$_elapsedSeconds sn sürdü',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getWpmFeedback(_calculatedWpm!),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getWpmColor(_calculatedWpm!),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Yeniden Ölç', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getWpmColor(int wpm) {
    if (wpm < 140) return AppColors.warning;
    if (wpm < 180) return AppColors.primaryLight;
    if (wpm <= 240) return AppColors.success;
    return const Color(0xFF8B5CF6);
  }

  String _getWpmFeedback(int wpm) {
    if (wpm < 140) {
      return '⚠️ Yavaş Hız: YDS paragraf sorularında zaman baskısı yaşamamak için 180+ WPM hedeflenmelidir.';
    } else if (wpm < 180) {
      return '👍 Orta Düzey: YDS için kabul edilebilir. Ancak soru çözümüne daha çok süre bırakmak için hızınızı artırabilirsiniz.';
    } else if (wpm <= 240) {
      return '🎯 İdeal YDS Hızı: ÖSYM paragraflarını hedeflenen sürede (2.5 - 3 dk) bitirme standardındasınız!';
    } else {
      return '🚀 Üstün Hız: Akademik metinleri olağanüstü hızla kavrıyorsunuz. Denemelerde ciddi zaman avantajı sağlar!';
    }
  }

  Widget _buildVocabularyTab(
    BuildContext context,
    ReadingArticle article,
    bool isDark,
  ) {
    final vocab = ref.watch(vocabularyProvider);

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: article.vocabulary.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final voc = article.vocabulary[index];
        final matchingWord = vocab.allWords.where(
          (w) => w.english.trim().toLowerCase() == voc.english.trim().toLowerCase(),
        ).firstOrNull;

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
                  Expanded(
                    child: Text(
                      voc.english,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      voc.turkish,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tanım: ${voc.definition}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (matchingWord != null) ...[
                    TextButton.icon(
                      onPressed: () {
                        ref.read(vocabularyProvider.notifier).markWordLearned(
                          matchingWord.id,
                          !matchingWord.isLearned,
                        );
                      },
                      icon: Icon(
                        matchingWord.isLearned ? Icons.check_circle : Icons.check_circle_outline,
                        size: 16,
                        color: matchingWord.isLearned ? AppColors.success : Colors.grey,
                      ),
                      label: Text(
                        matchingWord.isLearned ? 'Öğrenildi' : 'Öğrendim Olarak İşaretle',
                        style: TextStyle(
                          fontSize: 12,
                          color: matchingWord.isLearned ? AppColors.success : null,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        matchingWord.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        size: 20,
                        color: matchingWord.isFavorite ? AppColors.warning : Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(vocabularyProvider.notifier).toggleFavorite(matchingWord.id);
                      },
                      tooltip: 'Favoriye Ekle',
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '📚 YDS Reading Özel Kelimesi',
                        style: TextStyle(fontSize: 11, color: AppColors.primaryLight),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('"${voc.english}" kelimesi çalışma listenize kaydedildi.'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                      label: const Text('Listeme Ekle', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionsTab(
    BuildContext context,
    ReadingArticle article,
    bool isDark,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: article.questions.length,
      itemBuilder: (context, qIndex) {
        final q = article.questions[qIndex];
        final isSubmitted = _submittedQuestions.contains(qIndex);
        final selectedOption = _selectedAnswers[qIndex];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Soru ${qIndex + 1}: ${q.questionText}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),

              // Options
              ...List.generate(q.options.length, (optIndex) {
                final optText = q.options[optIndex];
                final isSelected = selectedOption == optIndex;
                final isCorrect = optIndex == q.correctIndex;

                Color bg = isDark ? Colors.white.withOpacity(0.04) : Colors.grey.withOpacity(0.05);
                Color border = Colors.grey.withOpacity(0.2);
                Color textCol = isDark ? Colors.white : AppColors.textLightPrimary;

                if (isSubmitted) {
                  if (isCorrect) {
                    bg = AppColors.success.withOpacity(0.15);
                    border = AppColors.success;
                    textCol = AppColors.success;
                  } else if (isSelected && !isCorrect) {
                    bg = AppColors.error.withOpacity(0.15);
                    border = AppColors.error;
                    textCol = AppColors.error;
                  }
                } else if (isSelected) {
                  bg = AppColors.primaryLight.withOpacity(0.12);
                  border = AppColors.primaryLight;
                }

                return GestureDetector(
                  onTap: isSubmitted
                      ? null
                      : () {
                          setState(() {
                            _selectedAnswers[qIndex] = optIndex;
                          });
                        },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      optText,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: textCol,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),

              if (!isSubmitted) ...[
                ElevatedButton(
                  onPressed: selectedOption == null
                      ? null
                      : () {
                          setState(() {
                            _submittedQuestions.add(qIndex);
                          });
                        },
                  child: const Text('Cevabı Kontrol Et'),
                ),
              ],

              if (isSubmitted) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedOption == q.correctIndex
                        ? const Color(0xFFF0FDF4)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    q.explanation,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
