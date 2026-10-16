import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/reading_article.dart';

class ReadingDetailScreen extends StatefulWidget {
  final ReadingArticle article;

  const ReadingDetailScreen({super.key, required this.article});

  @override
  State<ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<ReadingDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<int, int> _selectedAnswers = {};
  final Set<int> _submittedQuestions = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Widget _buildVocabularyTab(
    BuildContext context,
    ReadingArticle article,
    bool isDark,
  ) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: article.vocabulary.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final voc = article.vocabulary[index];
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
                  Text(
                    voc.english,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryLight,
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
