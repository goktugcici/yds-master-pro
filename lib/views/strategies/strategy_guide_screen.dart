import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class StrategyGuideScreen extends StatefulWidget {
  const StrategyGuideScreen({super.key});

  @override
  State<StrategyGuideScreen> createState() => _StrategyGuideScreenState();
}

class _StrategyGuideScreenState extends State<StrategyGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: const Text('YDS Taktik & Strateji Kartları'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.grey,
          indicatorColor: AppColors.primaryLight,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Edat & Prepositions'),
            Tab(text: 'Tense & Zaman Uyumu'),
            Tab(text: 'Devrik Yapılar (Inversion)'),
            Tab(text: 'Bağlaç Grupları'),
            Tab(text: 'ÖSYM Çeldirici Taktikleri'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Taktik veya kural ara...',
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                setState(() {
                  _searchQuery = val.toLowerCase().trim();
                });
              },
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPrepositionsTab(isDark),
                _buildTensesTab(isDark),
                _buildInversionTab(isDark),
                _buildConjunctionsTab(isDark),
                _buildSecretsTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: PREPOSITIONS ---
  Widget _buildPrepositionsTab(bool isDark) {
    final preps = [
      {
        'rule': 'insist on',
        'tr': 'ısrar etmek / üzerinde durmak',
        'example': 'She insisted on speaking to the manager directly.',
        'tip': 'ÖSYM preposition sorularında sıklıkla on ile sorulur.',
      },
      {
        'rule': 'lead to / contribute to',
        'tr': 'yol açmak / katkıda bulunmak',
        'example': 'Smoking leads to severe respiratory failure.',
        'tip': '"To" burada mastar eki değil edattır; arkasından isim veya Ving gelir.',
      },
      {
        'rule': 'rely on / depend on',
        'tr': 'güvenmek / bağlı olmak',
        'example': 'Developing countries rely on foreign agricultural aids.',
        'tip': 'Upon da kullanılabilir: rely upon / depend upon.',
      },
      {
        'rule': 'prevent from / deter from',
        'tr': 'engellemek / vazgeçirmek',
        'example': 'Strict measures prevented the disease from spreading.',
        'tip': 'prevent sb FROM doing sth kalıbı standarttır.',
      },
      {
        'rule': 'comply with / abide by',
        'tr': 'kurallara uymak / riayet etmek',
        'example': 'All staff must comply with the new safety regulations.',
        'tip': 'comply "with" alırken abide "by" alır! Çok sık sorulan çeldiricidir.',
      },
      {
        'rule': 'deprive of / rob of',
        'tr': 'yoksun bırakmak / mahrum etmek',
        'example': 'Sleep deprivation deprives people of critical cognitive skills.',
        'tip': '"Of" edatı burada mahrumiyeti ifade eder.',
      },
      {
        'rule': 'cope with / deal with',
        'tr': 'başa çıkmak / üstesinden gelmek',
        'example': 'The local council could not cope with the crisis.',
        'tip': 'Eş anlamlısı: tackle, handle.',
      },
      {
        'rule': 'stem from / derive from',
        'tr': '-den kaynaklanmak / türemek',
        'example': 'Most modern economic issues stem from resource misallocation.',
        'tip': 'Result from ile aynı anlamdadır. Result in ise yol açmak demektir.',
      },
      {
        'rule': 'be subject to',
        'tr': 'maruz kalmak / tabi olmak',
        'example': 'Imported electronics are subject to strict border tariffs.',
        'tip': 'Arkasından V1 değil, Noun veya Ving gelir!',
      },
      {
        'rule': 'regardless of / irrespective of',
        'tr': '-e bakılmaksızın / dikkate almaksızın',
        'example': 'Everyone has basic rights regardless of their nationality.',
        'tip': 'Paragraf ve cümle tamamlama sorularında zıtlık/tarafsızlık verir.',
      },
    ];

    final filtered = preps.where((item) {
      final text = "${item['rule']} ${item['tr']} ${item['example']}".toLowerCase();
      return _searchQuery.isEmpty || text.contains(_searchQuery);
    }).toList();

    return _buildList(filtered, isDark, icon: Icons.link);
  }

  // --- TAB 2: TENSES ---
  Widget _buildTensesTab(bool isDark) {
    final tenses = [
      {
        'rule': 'Zaman Uyumu Altın Kuralı',
        'tr': 'Present - Past Birleşmez!',
        'example': 'When he comes (Present), we will discuss it (Future).',
        'tip': 'Yan cümlecik Present ise ana cümle Past olamaz (Since istisnası hariç).',
      },
      {
        'rule': 'SINCE Altın Formülü',
        'tr': 'Since + Simple Past , Present Perfect (Have/Has V3)',
        'example': 'Since the company was founded in 1990, it has grown rapidly.',
        'tip': 'ÖSYM\'nin hemen hemen her sınavında garanti çıkan kuraldır!',
      },
      {
        'rule': 'BY THE TIME + Past',
        'tr': 'By the time + V2 , Had V3 (Past Perfect)',
        'example': 'By the time the ambulance arrived, the patient had recovered.',
        'tip': 'Geçmişte bir eylem olana kadar bir diğerinin çoktan tamamlandığını belirtir.',
      },
      {
        'rule': 'BY THE TIME + Present',
        'tr': 'By the time + V1 , Will Have V3 (Future Perfect)',
        'example': 'By the time we finish the project, a year will have passed.',
        'tip': 'Gelecekte belirli bir ana kadar tamamlanmış olacak eylemler.',
      },
      {
        'rule': 'Zaman Bağlaçlarında Will/Would Yasağı',
        'tr': 'When, As soon as, Once, Until + WILL/WOULD YASAKTIR',
        'example': 'As soon as the results are (WILL BE değil) announced, we will call you.',
        'tip': 'Zaman bağlacının olduğu yan cümlecikte asla will/would gelmez. Şıkları hemen ele!',
      },
    ];

    final filtered = tenses.where((item) {
      final text = "${item['rule']} ${item['tr']} ${item['example']}".toLowerCase();
      return _searchQuery.isEmpty || text.contains(_searchQuery);
    }).toList();

    return _buildList(filtered, isDark, icon: Icons.schedule);
  }

  // --- TAB 3: INVERSION ---
  Widget _buildInversionTab(bool isDark) {
    final inversions = [
      {
        'rule': 'Devrik Cümle Formülü',
        'tr': 'Negatif Zarf + Yardımcı Fiil + Özne + Ana Fiil',
        'example': 'Never have I seen such an impressive archaeological discovery.',
        'tip': 'Cümle olumsuz veya sınırlayıcı bir zarfla başlıyorsa soru cümlesi gibi devrilir.',
      },
      {
        'rule': 'Not only ... but also ...',
        'tr': 'Sadece ... değil, aynı zamanda ...',
        'example': 'Not only did they isolate the virus, but they also developed a vaccine.',
        'tip': 'Not only başa gelirse ilk cümle devrik (did they isolate), ikinci cümle düz kurulur.',
      },
      {
        'rule': 'Hardly / Scarcely ... when / before ...',
        'tr': 'Tam ... yapmıştı ki ... oldu (-er etmez)',
        'example': 'Hardly had the rocket launched when an engine failure occurred.',
        'tip': 'Hardly/Scarcely + Had + Özne + V3 ... WHEN/BEFORE kalıbı sabittir.',
      },
      {
        'rule': 'No sooner ... than ...',
        'tr': '... yapmasıyla ... olması bir oldu',
        'example': 'No sooner had she entered the office than the phone rang.',
        'tip': 'No sooner THAN ile kullanılır; Hardly ise WHEN ile kullanılır!',
      },
      {
        'rule': 'Only after / Only when ...',
        'tr': 'Ancak ...-dikten sonra',
        'example': 'Only after years of clinical trials was the drug approved for use.',
        'tip': 'Only after\'lı yan cümle düz kalır, ana cümle devrik yapılır (was the drug approved).',
      },
      {
        'rule': 'Under no circumstances / By no means',
        'tr': 'Hiçbir koşulda / Asla',
        'example': 'Under no circumstances must unauthorized personnel enter the laboratory.',
        'tip': 'ÖSYM resmi/akademik metinlerinde sıkça karşımıza çıkar.',
      },
    ];

    final filtered = inversions.where((item) {
      final text = "${item['rule']} ${item['tr']} ${item['example']}".toLowerCase();
      return _searchQuery.isEmpty || text.contains(_searchQuery);
    }).toList();

    return _buildList(filtered, isDark, icon: Icons.transform);
  }

  // --- TAB 4: CONJUNCTIONS ---
  Widget _buildConjunctionsTab(bool isDark) {
    final conjunctions = [
      {
        'rule': 'Zıtlık Grubu (Cümle Alanlar)',
        'tr': 'Although / Even though / Though / Whereas / While',
        'example': 'Although the economy grew, unemployment remained alarmingly high.',
        'tip': 'Arkasından tam cümle (Özne + Yüklem) gelir. Beklenmeyen sonuç bildirir.',
      },
      {
        'rule': 'Zıtlık Grubu (İsim/Ving Alanlar)',
        'tr': 'Despite / In spite of',
        'example': 'Despite heavy rainfall, the scientific expedition continued.',
        'tip': 'Arkasından ASLA cümle gelmez! İsim öbeği veya fiil+ing gelir. "Despite of" YANLIŞTIR!',
      },
      {
        'rule': 'Geçiş Sözcükleri (Noktalı Virgüllü Zıtlık)',
        'tr': 'However / Nevertheless / Nonetheless',
        'example': 'The budget was limited; however, the results exceeded expectations.',
        'tip': 'Genellikle iki bağımsız cümle arasında noktalama işaretiyle kullanılır.',
      },
      {
        'rule': 'Sebep - Sonuç (Cümle vs. İsim)',
        'tr': 'Because / Since / As (+ Cümle) vs. Due to / Owing to (+ İsim)',
        'example': 'Due to volcanic ash, flights were suspended.',
        'tip': 'Due to to edatı içerdiği için arkasından isim ister.',
      },
      {
        'rule': 'Koşul Bağlaçları',
        'tr': 'Unless (= If not) / Provided that / As long as',
        'example': 'Unless emissions are reduced, global warming will accelerate.',
        'tip': 'Unless olan yan cümle yapıcı olumlu olsa da anlamca olumsuzdur (azaltılmadıkça).',
      },
    ];

    final filtered = conjunctions.where((item) {
      final text = "${item['rule']} ${item['tr']} ${item['example']}".toLowerCase();
      return _searchQuery.isEmpty || text.contains(_searchQuery);
    }).toList();

    return _buildList(filtered, isDark, icon: Icons.alt_route);
  }

  // --- TAB 5: SECRETS ---
  Widget _buildSecretsTab(bool isDark) {
    final secrets = [
      {
        'rule': 'Extreme (Aşırı Genelleme) Kelimeler',
        'tr': 'always, only, strictly, completely, solely, entirely',
        'example': 'Paragrafta "genellikle" geçerken şıkta "solely / only" diyorsa %95 yanlıştır!',
        'tip': 'Akademik metinler temkinli dille (hedging) yazılır. Aşırı iddialı şıkları dikkatle eleyin.',
      },
      {
        'rule': 'Çeviri Sorularında 15 Saniye Taktiği',
        'tr': 'Özne ve Ana Fiil Takibi',
        'example': 'İlk olarak ana cümlenin öznesi ve yüklemini bulun.',
        'tip': 'Şıkları tek tek okumak yerine cümlenin yüklemini seçeneklerde arayın; 3 şık hemen elenir.',
      },
      {
        'rule': 'Anlamı Bozan Cümle (İrrelevant) Taktiği',
        'tr': 'Zamir ve Referans Sözcük Kilidi',
        'example': '"This finding, these approaches, such mechanisms" gibi referanslar köprüdür.',
        'tip': 'Köprüyü kesen veya genel konudan bir anda alakasız bir alt detaya sıçrayan cümleyi arayın.',
      },
      {
        'rule': 'Cümle Tamamlamada Zaman Uyumu',
        'tr': 'Present kök -> Present devam; Past kök -> Past devam',
        'example': 'Kök cümle Past ise şıklardaki "can, will, may" gibi Present modalları doğrudan eleyebilirsiniz.',
        'tip': 'İstisnalar: now, today, recently gibi günümüze bağlayan zarflardır.',
      },
      {
        'rule': 'Paragraf Tamamlamada Boşluk Öncesi & Sonrası',
        'tr': 'Bağlaç ve Zaman Eşleşmesi',
        'example': 'Boşluktan sonra "However" geliyorsa, boşluğa tam tersi bir düşünce gelmelidir.',
        'tip': 'Boşluğun hem önceki cümleyle hem de sonraki cümleyle çift yönlü uyumunu kontrol edin.',
      },
    ];

    final filtered = secrets.where((item) {
      final text = "${item['rule']} ${item['tr']} ${item['example']}".toLowerCase();
      return _searchQuery.isEmpty || text.contains(_searchQuery);
    }).toList();

    return _buildList(filtered, isDark, icon: Icons.psychology);
  }

  Widget _buildList(List<Map<String, String>> items, bool isDark, {required IconData icon}) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Eşleşen taktik bulunamadı.',
          style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: AppColors.primaryLight, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['rule']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['tr']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Example Sentence
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item['example']!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ÖSYM Tip Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ÖSYM İpucu: ${item['tip']!}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fade().slideY(begin: 0.05, end: 0, delay: (index * 30).ms);
      },
    );
  }
}
