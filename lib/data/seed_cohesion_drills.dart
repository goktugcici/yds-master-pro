import '../models/cohesion_drill.dart';

final List<CohesionDrill> defaultCohesionDrills = [
  // --- 1. ANLAM AKIŞINI BOZAN CÜMLE (IRRELEVANT SENTENCE) ---
  const CohesionDrill(
    id: 'cd_irr_1',
    type: CohesionType.irrelevantSentence,
    title: 'Kentsel Isı Adaları ve Yeşil Çatılar',
    topic: 'Çevre & Şehircilik',
    passage:
        '(I) Highly built-up metropolitan regions often create localized microclimates known as urban heat islands, where concrete and asphalt absorb vast amounts of solar radiation during daylight hours. '
        '(II) To counteract this hazardous thermal accumulation, municipal architects are progressively retrofitting public rooftops with extensive vegetation and reflective insulating membranes. '
        '(III) Studies demonstrate that widespread adoption of green roofs can lower city ambient temperatures by up to three degrees Celsius and significantly reduce summer cooling demands. '
        '(IV) Modern suburban commuter railways have experienced substantial fare increases due to rising diesel fuel costs. '
        '(V) Moreover, these rooftop gardens act as natural runoff sponges, absorbing torrential rainwater and alleviating municipal drainage loads.',
    options: ['A) I', 'B) II', 'C) III', 'D) IV', 'E) V'],
    correctIndex: 3, // D) IV
    keyClues: [
      'urban heat islands',
      'green roofs',
      'these rooftop gardens',
      'commuter railways',
    ],
    tacticExplanation:
        'ÖSYM ÇÖZÜM TAKTİĞİ (Zamir & Konu Bütünlüğü Takibi):\n'
        '• (I), (II) ve (III) numaralı cümleler kentsel ısı adalarını hafifletmek için kurulan "yeşil çatıları" (green roofs / rooftop vegetation) ve bunların sıcaklık düşürücü faydalarını anlatır.\n'
        '• (V) numaralı cümle "Moreover, these rooftop gardens..." (Üstelik bu çatı bahçeleri...) diyerek III numaralı cümlenin mantıksal devamını getirmektedir.\n'
        '• (IV) numaralı cümle ise araya girerek tamamen alakasız "banliyö trenlerinin bilet zamları"ndan bahsetmektedir. Akışı bozan cümle IV\'tür (D şıkkı).',
    translation:
        '(I) Yoğun yapılaşmış metropol bölgeleri, beton ve asfaltın gündüz saatlerinde büyük miktarda güneş radyasyonu emdiği kentsel ısı adaları oluşturur.\n'
        '(II) Bu tehlikeli termal birikime karşı koymak için belediye mimarları, kamu çatılarında kapsamlı bitki örtüsü ve yansıtıcı membranlar kullanmaktadır.\n'
        '(III) Çalışmalar, yeşil çatıların yaygınlaşmasının ortam sıcaklığını 3 dereceye kadar düşürebileceğini göstermektedir.\n'
        '(IV) Modern banliyö demir yolları, artan yakıt maliyetleri nedeniyle ciddi bilet zamları yaşamıştır.\n'
        '(V) Üstelik bu çatı bahçeleri, şiddetli yağmur suyunu emen doğal süngerler görevi görerek drenaj yükünü hafifletmektedir.',
  ),

  const CohesionDrill(
    id: 'cd_irr_2',
    type: CohesionType.irrelevantSentence,
    title: 'Antibiyotik Direnci ve Bakteriyel Evrim',
    topic: 'Tıp & Mikrobiyoloji',
    passage:
        '(I) Antibiotics have undeniably transformed clinical medicine since Alexander Fleming\'s serendipitous isolation of penicillin in 1928, saving hundreds of millions of lives. '
        '(II) However, relentless overprescription in outpatient clinics and intensive agricultural misuse have accelerated the evolutionary selection of multi-drug resistant superbugs. '
        '(III) Global pharmaceutical investments in developing novel antibiotic classes have precipitously declined because chronic illness medications yield vastly superior profit margins. '
        '(IV) Dental implants require sterile titanium screws that physically fuse with the human jawbone through osseointegration. '
        '(V) Consequently, the World Health Organization has declared antimicrobial resistance one of the top ten public health threats humanity faces in the twenty-first century.',
    options: ['A) I', 'B) II', 'C) III', 'D) IV', 'E) V'],
    correctIndex: 3, // D) IV
    keyClues: [
      'Antibiotics',
      'superbugs',
      'novel antibiotic classes',
      'antimicrobial resistance',
      'Dental implants',
    ],
    tacticExplanation:
        'ÖSYM ÇÖZÜM TAKTİĞİ (Konu Kapsamından Sapma):\n'
        '• Metin bütünüyle antibiyotiklerin keşfi, aşırı kullanım sonucu ortaya çıkan "dirençli süper mikroplar" (superbugs / antimicrobial resistance) ve ilaç geliştirme sorunları hakkındadır.\n'
        '• (IV) numaralı cümle ise diş implantları ve titanyum vidalardan bahsederek mikrobiyoloji ve antibiyotik konusundan tamamen kopmuştur.',
    translation:
        '(I) Antibiyotikler, 1928\'de penisilinin keşfinden bu yana yüz milyonlarca hayat kurtararak klinik tıbbı dönüştürmüştür.\n'
        '(II) Ancak aşırı reçeteleme ve tarımsal suistimal, çoklu ilaca dirençli süper mikropların evrimsel gelişimini hızlandırmıştır.\n'
        '(III) Kronik hastalık ilaçlarının çok daha yüksek kâr marjı sağlaması nedeniyle yeni antibiyotik sınıfları geliştirmeye yönelik küresel yatırımlar hızla azalmıştır.\n'
        '(IV) Diş implantları, insan çene kemiğiyle kaynaşan steril titanyum vidalar gerektirir.\n'
        '(V) Sonuç olarak Dünya Sağlık Örgütü, antimikrobiyal direnci insanlığın karşı karşıya olduğu en büyük on sağlık tehdidinden biri ilan etmiştir.',
  ),

  const CohesionDrill(
    id: 'cd_irr_3',
    type: CohesionType.irrelevantSentence,
    title: 'Rönesans Döneminde Matbaanın Doğuşu',
    topic: 'Tarih & Kültür',
    passage:
        '(I) Johannes Gutenberg\'s invention of movable metallic type in the mid-fifteenth century drastically lowered the labor and prohibitive expense of text reproduction. '
        '(II) Prior to this breakthrough, hand-copied illuminated manuscripts were monopolized by aristocratic scriptoria and monastic libraries. '
        '(III) The ensuing proliferation of printed literature catalyzed the spread of scientific discourse, religious reformation, and vernacular languages across Western Europe. '
        '(IV) Modern lithium-ion batteries are prone to overheating if manufactured with impure electrolytic salts. '
        '(V) By democratizing access to recorded knowledge, printing fundamentally altered the cognitive trajectory of human civilization.',
    options: ['A) I', 'B) II', 'C) III', 'D) IV', 'E) V'],
    correctIndex: 3, // D) IV
    keyClues: [
      'movable metallic type',
      'hand-copied illuminated manuscripts',
      'printed literature',
      'democratizing access to recorded knowledge',
      'lithium-ion batteries',
    ],
    tacticExplanation:
        'ÖSYM ÇÖZÜM TAKTİĞİ (Zaman & Alan Tutarsızlığı):\n'
        '• Metin 15. yüzyıl matbaa devrimi (Gutenberg), el yazmalarının sonu ve bilginin yayılması üzerinedir.\n'
        '• (IV) numaralı cümle modern lityum-iyon pillerden bahsettiği için tarihsel ve tematik akışı derhal bozar.',
    translation:
        '(I) Gutenberg\'in hareketli metal baskı makinesini icadı, metin çoğaltmanın yüksek maliyetini ve iş gücünü çarpıcı biçimde düşürdü.\n'
        '(II) Bu buluştan önce el yazması eserler manastır ve soylu kütüphanelerinin tekelindeydi.\n'
        '(III) Basılı edebiyatın yaygınlaşması bilimsel düşünceyi, reform hareketini ve yerel dillerin gelişimini hızlandırdı.\n'
        '(IV) Modern lityum-iyon piller, saf olmayan elektrolitlerle üretildiğinde aşırı ısınmaya eğilimlidir.\n'
        '(V) Bilgiye erişimi demokratikleştiren matbaa, insan uygarlığının zihinsel gidişatını temelden değiştirdi.',
  ),

  // --- 2. PARAGRAF TAMAMLAMA (PARAGRAPH COMPLETION) ---
  const CohesionDrill(
    id: 'cd_cmp_1',
    type: CohesionType.paragraphCompletion,
    title: 'Derin Deniz Canlılarında Biyolüminesans',
    topic: 'Deniz Biyolojisi',
    passage:
        'In the abyssal depths of the oceanic bathypelagic zone, sunlight is completely extinguished, plunging the ecosystem into perpetual darkness. '
        'To navigate, hunt, and communicate in this hostile gloom, an overwhelming majority of deep-sea organisms have evolved bioluminescence—the biochemical production of living light. '
        '[ __________________________________________________ ] '
        'For instance, the female anglerfish projects a glowing dorsal filament directly over its jaws, enticing unsuspecting prey into its striking range like a luminous fishing lure.',
    options: [
      'A) However, commercial deep-sea trawling fleets have caused catastrophic disruption to cold-water coral formations.',
      'B) This living light serves diverse adaptive purposes, ranging from predatory deception to partner recognition and counter-illumination camouflage.',
      'C) Photosynthesis remains the fundamental engine of biological productivity across terrestrial rain forests.',
      'D) Most oceanic trenches were formed through tectonic subduction millions of years before the Jurassic period.',
      'E) Geologists study basaltic seafloor samples to reconstruct changes in the Earth\'s geomagnetic orientation.',
    ],
    correctIndex: 1, // B
    keyClues: [
      'This living light',
      'diverse adaptive purposes',
      'For instance, the female anglerfish',
    ],
    tacticExplanation:
        'ÖSYM ÇÖZÜM TAKTİĞİ (Örnekleme & Gönderim İlişkisi):\n'
        '• Boşluktan hemen sonraki cümle: "For instance, the female anglerfish projects a glowing filament..." (Örneğin dişi fener balığı avını çekmek için ışıldayan bir uzantı kullanır...).\n'
        '• "For instance" (Örneğin) ifadesi, kendisinden önceki genel bir kuralı veya çoklu amacı somutlaştırmak için gelir.\n'
        '• B seçeneğindeki "This living light serves diverse adaptive purposes..." (Bu canlı ışık avcı aldatmacasından eş tanımaya kadar çeşitli adaptif amaçlara hizmet eder) cümlesi hem "bioluminescence" kavramına "This living light" ile referans verir hem de bir sonraki cümlenin avcı fener balığı örneği için mükemmel bir genel çerçeve kurar.',
    translation:
        'Okyanusun batipelajik derinliklerinde güneş ışığı tamamen kaybolur ve ekosistem ebedi bir karanlığa gömülür. Bu kasvetli ortamda yol bulmak, avlanmak ve iletişim kurmak için canlıların büyük kısmı biyolüminesans (yaşayan ışık üretimi) yeteneği geliştirmiştir. [ B seçeneği: Bu yaşayan ışık, avcı aldatmacasından partner tanımaya kadar çeşitli adaptif amaçlara hizmet eder. ] Örneğin dişi fener balığı, çenesinin hemen üzerine uzanan ışıklı bir uzantı ile avını kendine çeker.',
  ),

  const CohesionDrill(
    id: 'cd_cmp_2',
    type: CohesionType.paragraphCompletion,
    title: 'Çok Dilli Bireylerde Bilişsel Esneklik',
    topic: 'Psikoloji & Nörobilim',
    passage:
        'For decades, developmental psychologists erroneously assumed that exposing young children to two languages simultaneously would confuse linguistic syntax and impede cognitive maturity. '
        'However, robust contemporary neuroimaging experiments have decisively demolished this historical misconception. '
        '[ __________________________________________________ ] '
        'Because their brains are constantly suppressing one lexical code while activating another, bilingual individuals develop superior executive control, enhanced working memory, and stronger conflict resolution skills.',
    options: [
      'A) On the contrary, managing multiple linguistic systems appears to train and fortify the brain\'s prefrontal cortex like mental gymnastics.',
      'B) Consequently, children frequently prefer playing physical sports outdoors rather than memorizing vocabulary cards.',
      'C) Atmospheric carbon levels were notably lower during the pre-industrial agrarian era.',
      'D) Many ancient alphabets lacked vowels and were inscribed solely upon clay tablets.',
      'E) High-fat diets can increase serum cholesterol concentrations in adult patients.',
    ],
    correctIndex: 0, // A
    keyClues: [
      'On the contrary',
      'train and fortify the brain',
      'Because their brains are constantly...',
    ],
    tacticExplanation:
        'ÖSYM ÇÖZÜM TAKTİĞİ (Zıtlık Bağlacı ve Sebep-Sonuç Tamamlayıcısı):\n'
        '• Önceki cümle: Eski inanışın ("iki dil kafayı karıştırır") modern nörogörüntüleme deneyleriyle kesin olarak çürütüldüğünü söylüyor.\n'
        '• Sonraki cümle: "Because their brains are constantly suppressing..." (Çünkü beyinleri sürekli bir dil kodunu baskılarken diğerini aktive ettiği için üstün yönetici kontrol geliştirirler).\n'
        '• A seçeneği: "On the contrary, managing multiple linguistic systems appears to train the brain..." (Aksine, birden fazla dil sistemini yönetmek beyni zihinsel bir jimnastik gibi eğitip güçlendirir). Bu cümle hem önceki miti "On the contrary" ile reddeder hem de sonraki cümlenin "Because..." gerekçesine mükemmel bir temel atar.',
    translation:
        'On yıllar boyunca gelişim psikologları, çocukları aynı anda iki dile maruz bırakmanın bilişsel gelişimi engelleyeceğini varsaydı. Ancak çağdaş nörogörüntüleme deneyleri bu yanılgıyı yıktı. [ A seçeneği: Aksine, birden fazla dil sistemini yönetmek beyni zihinsel bir jimnastik gibi eğitip güçlendirmektedir. ] Çünkü beyinleri bir dil kodunu baskılarken diğerini aktif tuttuğu için iki dilli bireyler üstün odaklanma ve hafıza becerileri geliştirirler.',
  ),
];
