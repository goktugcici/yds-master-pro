import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_translation_drills.dart';
import '../../models/translation_drill.dart';

class TranslationLabScreen extends StatefulWidget {
  const TranslationLabScreen({super.key});

  @override
  State<TranslationLabScreen> createState() => _TranslationLabScreenState();
}

class _TranslationLabScreenState extends State<TranslationLabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Practice state
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerSubmitted = false;
  bool _showDissection = true;
  TranslationDirection? _filterDirection;

  List<TranslationDrill> get _filteredDrills {
    if (_filterDirection == null) return defaultTranslationDrills;
    return defaultTranslationDrills
        .where((d) => d.direction == _filterDirection)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Çeviri Laboratuvarı & Öge Analizi'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryLight,
          indicatorWeight: 3,
          labelColor: isDark ? Colors.white : AppColors.primaryLight,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.school), text: 'ÖSYM Çeviri Sırları'),
            Tab(icon: Icon(Icons.architecture), text: 'Cümle Çözümleme & Pratik'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTacticsTab(isDark),
          _buildPracticeTab(isDark),
        ],
      ),
    );
  }

  // --- TAB 1: ÖSYM Çeviri Stratejileri ---
  Widget _buildTacticsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTacticCard(
          title: '1. Temel Yüklem & Zaman Uyumu (Main Verb & Tense)',
          subtitle: '6 Soruda 7.5 Netin En Hızlı Anahtarı',
          icon: Icons.flash_on,
          color: const Color(0xFF10B981),
          content:
              'ÖSYM İngilizce-Türkçe ve Türkçe-İngilizce çeviri sorularının en güçlü eleme yöntemi yüklem kontrolüdür:\n\n'
              '• İngilizce cümlenin ana fiili Türkçede daima en sondaki YÜKLEMDİR.\n'
              '• Kip kontrolü: "has transformed" (Present Perfect) -> "dönüştürmüştür" olur. "dönüştürüyor" (şimdiki) veya "dönüştürecektir" (gelecek) diyen şıkları 5 saniyede eleyin!\n'
              '• Modal kontrolü: "must be protected" -> "korunmalıdır", "could have prevented" -> "önleyebilirdi ama önlemedi".\n\n'
              '💡 Taktik: Soru kökünün ana fiilini yuvarlak içine alın, 5 seçeneğin sadece son kelimelerine (yüklemlerine) bakın. Genellikle 3 seçenek anında elenir!',
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildTacticCard(
          title: '2. Özne Tespiti & Sıfat Cümlecikleri (Subject & Relatives)',
          subtitle: 'Özneye Bağlı Sıfat Gruplarını Ayırın',
          icon: Icons.person_search,
          color: const Color(0xFF3B82F6),
          content:
              'Uzun YDS cümlelerinde özne genellikle sıfat cümlecikleriyle (Relative Clauses / Participles) genişletilir:\n\n'
              '• "Göbeklitepe, located in southeastern Anatolia..." -> Özne Göbeklitepe\'dir ("Güneydoğu Anadolu\'da yer alan Göbeklitepe").\n'
              '• Yanlış şıklarda ÖSYM özne ile nesneyi yer değiştirir veya pasif cümlenin failini özne yapar.\n\n'
              '💡 Taktik: Yükleme "Kim / Ne?" sorusunu sorun. Çıkan yanıt Türkçe cümlenin de başında yer almak zorundadır.',
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildTacticCard(
          title: '3. Zarf Cümlecikleri & Şart Bağlaçları (Adverbial Clauses)',
          subtitle: 'Bağlacın Yerini ve Anlamını Koruyun',
          icon: Icons.alt_route,
          color: const Color(0xFFF59E0B),
          content:
              'ÖSYM sıklıkla zıtlık, şart ve neden-sonuç bağlaçlarını şıklarda çarpıtır:\n\n'
              '• "Although / Even though" -> "...-e rağmen / ...-mesine karşın" olmalıdır. "fakat / ama" (but) koordinasyonuna çeviren şıklar elenir.\n'
              '• "Unless" -> "...-medikçe / ...-madıkça / eğer ... -mezse" olmalıdır. "olsa bile" diyen şıklar elenir.\n'
              '• "Thereby + Ving" -> "böylece / bu sayede ... -erek" şeklinde sonuç ve tarz bildirir.',
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildTacticCard(
          title: '4. İkili Kalıplar ve Devrik Yapılar (Correlative Conjunctions)',
          subtitle: 'Not only... but also & As well as',
          icon: Icons.sync_alt,
          color: const Color(0xFF8B5CF6),
          content:
              'ÖSYM sınavında en sık sorulan ikili kalıpların çeviri karşılıkları:\n\n'
              '• "not only ... but also ..." -> "...-makla kalmayıp ... da / aynı zamanda ..."\n'
              '• "neither ... nor ..." -> "ne ... ne de ... (fiil olumlu olsa da anlam olumsuzdur)"\n'
              '• "both ... and ..." -> "hem ... hem de ..."\n\n'
              '💡 Bu kalıplardan birini gördüğünüzde seçeneklerde bu kalıbın birebir Türkçe karşılığı olmayanları hemen eleyin.',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildTacticCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String content,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 13.5, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: Cümle Çözümleme & İnteraktif Soru Çözümü ---
  Widget _buildPracticeTab(bool isDark) {
    final drills = _filteredDrills;
    if (drills.isEmpty) {
      return const Center(child: Text('Bu filtreye uygun soru bulunamadı.'));
    }

    final currentDrill = drills[_currentIndex.clamp(0, drills.length - 1)];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Chips
          Row(
            children: [
              FilterChip(
                label: const Text('Tümü (5)'),
                selected: _filterDirection == null,
                onSelected: (_) {
                  setState(() {
                    _filterDirection = null;
                    _currentIndex = 0;
                    _resetQuestion();
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('EN ➔ TR (Soru 37-39)'),
                selected:
                    _filterDirection == TranslationDirection.englishToTurkish,
                onSelected: (_) {
                  setState(() {
                    _filterDirection = TranslationDirection.englishToTurkish;
                    _currentIndex = 0;
                    _resetQuestion();
                  });
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('TR ➔ EN (Soru 40-42)'),
                selected:
                    _filterDirection == TranslationDirection.turkishToEnglish,
                onSelected: (_) {
                  setState(() {
                    _filterDirection = TranslationDirection.turkishToEnglish;
                    _currentIndex = 0;
                    _resetQuestion();
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Header Info Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentDrill.directionLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentDrill.topic,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              Text(
                'Soru ${_currentIndex + 1} / ${drills.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Original Sentence Card with Sentence Dissection Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Orijinal Metin / Cümle:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showDissection = !_showDissection;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showDissection
                            ? const Color(0xFF0F766E)
                            : Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: Icon(
                        _showDissection
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 15,
                        color: Colors.white,
                      ),
                      label: Text(
                        _showDissection ? 'Ögeleri Gizle' : 'Ögelerine Ayır',
                        style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  currentDrill.originalSentence,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Sentence Dissection Breakdown
                if (_showDissection) ...[
                  const Divider(height: 24),
                  const Text(
                    '🔍 Öge Ayrıştırma & Cümle Haritası (S-V-O Matrix):',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...currentDrill.components.map((comp) {
                    Color badgeColor;
                    switch (comp.roleCode) {
                      case 'subject':
                        badgeColor = const Color(0xFF2563EB); // Blue
                        break;
                      case 'verb':
                        badgeColor = const Color(0xFF059669); // Emerald Green
                        break;
                      case 'object':
                        badgeColor = const Color(0xFF7C3AED); // Purple
                        break;
                      default:
                        badgeColor = const Color(0xFFD97706); // Amber
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: badgeColor.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              comp.label,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comp.text,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Golden Rule Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFFD97706), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentDrill.goldenRule,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Options A, B, C, D, E
          ...List.generate(currentDrill.options.length, (optIdx) {
            final isSelected = _selectedAnswerIndex == optIdx;
            final isCorrect = currentDrill.correctIndex == optIdx;

            Color bgColor = isDark ? AppColors.cardDark : Colors.white;
            Color borderColor =
                isDark ? AppColors.borderDark : AppColors.borderLight;
            Color textColor = isDark ? Colors.white : Colors.black87;

            if (_isAnswerSubmitted) {
              if (isCorrect) {
                bgColor = AppColors.success.withValues(alpha: 0.15);
                borderColor = AppColors.success;
                textColor = AppColors.success;
              } else if (isSelected && !isCorrect) {
                bgColor = AppColors.error.withValues(alpha: 0.15);
                borderColor = AppColors.error;
                textColor = AppColors.error;
              }
            } else if (isSelected) {
              bgColor = AppColors.primaryLight.withValues(alpha: 0.12);
              borderColor = AppColors.primaryLight;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
              ),
              child: InkWell(
                onTap: _isAnswerSubmitted
                    ? null
                    : () {
                        setState(() {
                          _selectedAnswerIndex = optIdx;
                        });
                      },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentDrill.options[optIdx],
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: textColor,
                        ),
                      ),
                      // Distractor reason on submission
                      if (_isAnswerSubmitted) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentDrill.distractorAnalysis[optIdx] ?? '',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isCorrect
                                  ? AppColors.success
                                  : (isDark
                                      ? Colors.red[300]
                                      : Colors.red[800]),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Bottom Action: Check Answer or Next Question
          if (!_isAnswerSubmitted) ...[
            ElevatedButton(
              onPressed: _selectedAnswerIndex == null
                  ? null
                  : () {
                      setState(() {
                        _isAnswerSubmitted = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Cevabı Kontrol Et & Analizi İncele',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (_currentIndex < drills.length - 1) {
                    _currentIndex++;
                  } else {
                    _currentIndex = 0;
                  }
                  _resetQuestion();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                _currentIndex < drills.length - 1
                    ? 'Sonraki Çeviri Sorusuna Geç'
                    : 'Başa Dön ve Tekrar Çöz',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _resetQuestion() {
    _selectedAnswerIndex = null;
    _isAnswerSubmitted = false;
  }
}
