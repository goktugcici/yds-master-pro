import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_cohesion_drills.dart';
import '../../models/cohesion_drill.dart';

class CohesionLabScreen extends StatefulWidget {
  const CohesionLabScreen({super.key});

  @override
  State<CohesionLabScreen> createState() => _CohesionLabScreenState();
}

class _CohesionLabScreenState extends State<CohesionLabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentDrillIndex = 0;
  int? _selectedOption;
  bool _isSubmitted = false;
  bool _showClues = false;

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

  void _nextDrill() {
    setState(() {
      _currentDrillIndex = (_currentDrillIndex + 1) % defaultCohesionDrills.length;
      _selectedOption = null;
      _isSubmitted = false;
      _showClues = false;
    });
  }

  void _previousDrill() {
    setState(() {
      _currentDrillIndex =
          (_currentDrillIndex - 1 + defaultCohesionDrills.length) % defaultCohesionDrills.length;
      _selectedOption = null;
      _isSubmitted = false;
      _showClues = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metin Bütünlüğü & Akış Laboratuvarı'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryLight,
          indicatorWeight: 3,
          labelColor: isDark ? Colors.white : AppColors.primaryLight,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
          tabs: const [
            Tab(icon: Icon(Icons.school), text: 'ÖSYM Taktik Sırları'),
            Tab(icon: Icon(Icons.psychology_alt), text: 'İnteraktif Soru Çözücü'),
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

  // --- TAB 1: ÖSYM Taktik Sırları ---
  Widget _buildTacticsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildTacticCard(
          title: '1. Zamir & Gönderim İfadeleri Takibi (Pronoun Reference)',
          subtitle: 'ÖSYM\'nin 1 Numaralı Eleme Silahı',
          icon: Icons.link,
          color: const Color(0xFF3B82F6),
          content:
              'Paragrafta bir cümlenin başında şu ifadeler varsa, o cümle ASLA tek başına veya ilk cümle olamaz:\n\n'
              '• this / that / these / those (örn: this finding, these obstacles)\n'
              '• such + isim (örn: such dramatic transformations)\n'
              '• they / their / it / its (önceki cümlede bu çoğul veya tekil özne mutlaka açıkça geçmelidir)\n'
              '• the former / the latter (önceki cümlede iki unsur sıralanmış olmalıdır)\n\n'
              '💡 Altın Kural: Boşluktan sonraki cümlede "these findings" diyorsa, boşluğa gelecek cümlede mutlaka bir "araştırma / bulgu / sonuç" geçmek zorundadır!',
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        _buildTacticCard(
          title: '2. Zıtlık & Geçiş İfadeleriyle Akış Tespiti',
          subtitle: 'Düşüncenin Yön Değiştirdiği Noktalar',
          icon: Icons.swap_horiz,
          color: const Color(0xFFEA580C),
          content:
              'Zıtlık bağlaçları metnin yönünü (+) dan (-) ye ya da (-) den (+) ya çevirir:\n\n'
              '• however, nevertheless, nonetheless, yet (Ancak, yine de)\n'
              '• on the contrary, conversely (Aksine, tam tersine - önceki yanlışı düzeltir)\n'
              '• on the other hand, in contrast (Öte yandan - iki farklı durumu kıyaslar)\n\n'
              '💡 Altın Kural: Eğer önceki cümle olumluysa ve bağlaç "However" ise, sonraki cümle kesinlikle bir sorun, engel veya istisnadan bahsetmelidir.',
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        _buildTacticCard(
          title: '3. Anlam Akışını Bozan Cümleyi (Cümle Atma) Bulma',
          subtitle: '1-2-3-4-5 Numaralı Cümlelerde Şüphe Odakları',
          icon: Icons.delete_sweep,
          color: const Color(0xFFDC2626),
          content:
              'ÖSYM akışı bozan cümleyi genellikle 3 şekilde kurgular:\n\n'
              '1. Konu aynı ama Kapsam Farklı: Metin dinozorların yok oluşunu anlatırken bir cümle dinozorların boyutsal sınıflandırmasından bahsedebilir.\n'
              '2. Zamir Boşluğu (Kopukluk): III numaralı cümleyi çıkardığınızda II ve IV numaralı cümleler birbirine "Moreover, these..." gibi bir bağla bağlanıyorsa, aradaki III fazlalıktır.\n'
              '3. Genelden Aşırı Özele Geçiş: Genel çevre kirliliği metninde aniden "Kuzey Kutbu kürk avcıları"ndan bahsediliyorsa o cümle atılmalıdır.',
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        _buildTacticCard(
          title: '4. Kronolojik Sıralama ve Zaman Kaymaları',
          subtitle: 'Tense ve Yıl İfadelerinin Uyumu',
          icon: Icons.history_toggle_off,
          color: const Color(0xFF059669),
          content:
              'Tarih ve biyografi paragraflarında zaman çizgisi asla geriye sıçramaz:\n\n'
              '• In the early 19th century → Later in 1845 → By the turn of the century → Today\n'
              '• Eğer 1950 yılından bahsederken aniden Antik Mısır\'a dönüyorsa ve hiçbir kıyaslama bağlacı yoksa, o cümle akışı bozmaktadır.',
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: İnteraktif Soru Çözücü & İpucu Vurgulayıcı ---
  Widget _buildPracticeTab(bool isDark) {
    final drill = defaultCohesionDrills[_currentDrillIndex];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drill Nav Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: drill.type == CohesionType.irrelevantSentence
                          ? const Color(0xFFDC2626).withValues(alpha: 0.12)
                          : const Color(0xFF059669).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      drill.typeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: drill.type == CohesionType.irrelevantSentence
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF059669),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    drill.topic,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54),
                  ),
                ],
              ),
              Text(
                '${_currentDrillIndex + 1} / ${defaultCohesionDrills.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Passage Container with Clue Highlighting
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      drill.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    // Clue Toggle Button
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _showClues = !_showClues);
                      },
                      icon: Icon(
                        _showClues ? Icons.lightbulb : Icons.lightbulb_outline,
                        size: 18,
                        color: _showClues ? const Color(0xFFF59E0B) : Colors.grey,
                      ),
                      label: Text(
                        _showClues ? 'İpuçlarını Gizle' : 'İpuçlarını Göster',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: _showClues ? const Color(0xFFF59E0B) : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildHighlightedPassage(drill.passage, drill.keyClues, _showClues, isDark),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Options List
          ...List.generate(drill.options.length, (optIdx) {
            final opt = drill.options[optIdx];
            final isSelected = _selectedOption == optIdx;
            final isCorrect = optIdx == drill.correctIndex;

            Color bg = isDark ? AppColors.cardDark : Colors.white;
            Color border = isDark ? AppColors.borderDark : AppColors.borderLight;
            Color textCol = isDark ? Colors.white : AppColors.textLightPrimary;

            if (_isSubmitted) {
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
                onTap: _isSubmitted
                    ? null
                    : () {
                        setState(() {
                          _selectedOption = optIdx;
                        });
                      },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border, width: isSelected ? 2 : 1),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: textCol,
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // Submit Button
          if (!_isSubmitted)
            ElevatedButton(
              onPressed: _selectedOption == null
                  ? null
                  : () {
                      setState(() {
                        _isSubmitted = true;
                        _showClues = true;
                      });
                    },
              child: const Text('Cevabı Onayla & Taktik Analizi Gör'),
            ),

          // Explanation Card
          if (_isSubmitted) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOption == drill.correctIndex
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedOption == drill.correctIndex
                      ? const Color(0xFFBBF7D0)
                      : const Color(0xFFFECACA),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _selectedOption == drill.correctIndex
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _selectedOption == drill.correctIndex
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedOption == drill.correctIndex
                            ? 'Harika! Doğru Seçim'
                            : 'Doğru Cevap: ${drill.options[drill.correctIndex]}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    drill.tacticExplanation,
                    style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF1E293B)),
                  ),
                  const Divider(height: 20),
                  const Text(
                    'Paragrafın Türkçe Çevirisi:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    drill.translation,
                    style: const TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousDrill,
                    child: const Text('Önceki Soru'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextDrill,
                    child: const Text('Sonraki Soru'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightedPassage(
    String passage,
    List<String> clues,
    bool showClues,
    bool isDark,
  ) {
    if (!showClues || clues.isEmpty) {
      return Text(
        passage,
        style: const TextStyle(fontSize: 14.5, height: 1.6),
      );
    }

    final spans = <TextSpan>[];
    String lowerPassage = passage.toLowerCase();
    int currentPos = 0;

    // Find occurrences of clues
    final matches = <MapEntry<int, int>>[]; // start -> end
    for (final clue in clues) {
      final clueLower = clue.toLowerCase();
      int start = 0;
      while ((start = lowerPassage.indexOf(clueLower, start)) != -1) {
        matches.add(MapEntry(start, start + clue.length));
        start += clue.length;
      }
    }

    matches.sort((a, b) => a.key.compareTo(b.key));

    for (final m in matches) {
      if (m.key < currentPos) continue; // Skip overlaps
      if (m.key > currentPos) {
        spans.add(TextSpan(text: passage.substring(currentPos, m.key)));
      }
      spans.add(
        TextSpan(
          text: passage.substring(m.key, m.value),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            backgroundColor: const Color(0xFFFDE68A),
            color: const Color(0xFF78350F),
          ),
        ),
      );
      currentPos = m.value;
    }

    if (currentPos < passage.length) {
      spans.add(TextSpan(text: passage.substring(currentPos)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.5,
          height: 1.6,
          color: isDark ? Colors.white : AppColors.textLightPrimary,
        ),
        children: spans,
      ),
    );
  }
}
