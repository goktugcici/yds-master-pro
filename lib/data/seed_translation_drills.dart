import '../models/translation_drill.dart';

final List<TranslationDrill> defaultTranslationDrills = [
  // 1. EN -> TR (Biyoloji & Sağlık)
  const TranslationDrill(
    id: 'tr_01',
    direction: TranslationDirection.englishToTurkish,
    topic: 'Tıp & Sağlık Bilimleri',
    originalSentence:
        'Although regular physical exercise has long been known to strengthen the cardiovascular system, recent clinical trials suggest that it also plays a crucial role in preventing neurodegenerative disorders by boosting brain elasticity.',
    components: [
      SentenceComponent(
        label: 'Zarf Cümleciği (Zıtlık Bağlacı)',
        text: 'Although regular physical exercise has long been known to strengthen the cardiovascular system',
        roleCode: 'clause',
      ),
      SentenceComponent(
        label: 'Ana Cümlenin Öznesi (Subject)',
        text: 'recent clinical trials',
        roleCode: 'subject',
      ),
      SentenceComponent(
        label: 'Ana Yüklem (Main Verb)',
        text: 'suggest that',
        roleCode: 'verb',
      ),
      SentenceComponent(
        label: 'Nesne & Amaç/Tarz İfadesi (Object & Means)',
        text: 'it also plays a crucial role in preventing neurodegenerative disorders by boosting brain elasticity',
        roleCode: 'object',
      ),
    ],
    options: [
      'A) Düzenli fiziksel egzersizin kardiyovasküler sistemi güçlendirdiği uzun zamandır bilinmektedir, fakat son klinik deneyler beyin elastikiyetini artırarak nörodejeneratif hastalıkları tamamen ortadan kaldırdığını göstermektedir.',
      'B) Düzenli fiziksel egzersizin kardiyovasküler sistemi güçlendirdiği uzun süredir bilinmesine rağmen, son klinik araştırmalar egzersizin beyin esnekliğini artırarak nörodejeneratif bozuklukları önlemede de kritik bir rol oynadığını öne sürmektedir.',
      'C) Son klinik araştırmalar, beyin esnekliğini artıran düzenli fiziksel egzersizin yalnızca kardiyovasküler sistemi güçlendirmekle kalmayıp aynı zamanda nörodejeneratif bozuklukları da engellediğini kanıtlamıştır.',
      'D) Kardiyovasküler sistemi güçlendirdiği bilinen düzenli egzersiz, nörodejeneratif bozuklukların önlenmesinde beyin esnekliğini artırdığı için son klinik çalışmalarda önemli bir rol oynamıştır.',
      'E) Son klinik deneylere göre, düzenli fiziksel egzersiz uzun süredir kardiyovasküler sistemi güçlendirmek için yapılsa da asıl kritik rolü beyin elastikiyetini artırmaktadır.',
    ],
    correctIndex: 1,
    distractorAnalysis: {
      0: 'A şıkkında "Although" bağlacı yerine "fakat" koordinasyon bağlacı kullanılmış ve "tamamen ortadan kaldırdığı" şeklinde abartılı bir anlam katılmıştır.',
      1: 'DOĞRU CEVAP: "Although... bilinmesine rağmen", ana özne "son klinik araştırmalar", ana yüklem "öne sürmektedir (suggest)", "by boosting... artırarak". Tam ve eksiksiz örtüşmektedir.',
      2: 'C şıkkında ana yüklem "kanıtlamıştır (has proven)" yapılmıştır, oysa orijinal metinde "suggest (öne sürmektedir)" kipi kullanılmıştır.',
      3: 'D şıkkında cümle yapısı bozulmuş, ana özne ve yüklem tamamen yer değiştirmiştir.',
      4: 'E şıkkında "Although" yapısı atlanmış, "yapılsa da asıl kritik rolü..." şeklinde metinde olmayan yorum eklenmiştir.',
    },
    goldenRule:
        'ÖSYM EN-TR Çeviri Altın Kuralı: Ana cümlenin yüklemini bulun ("suggest that" -> "öne sürmektedir"). Seçeneklerde yüklemi "kanıtlamıştır", "göstermektedir" veya "oynamıştır" olan şıkları ilk 10 saniyede eleyin!',
    fullTranslation:
        'Düzenli fiziksel egzersizin kardiyovasküler sistemi güçlendirdiği uzun süredir bilinmesine rağmen, son klinik araştırmalar egzersizin beyin esnekliğini artırarak nörodejeneratif bozuklukları önlemede de kritik bir rol oynadığını öne sürmektedir.',
  ),

  // 2. TR -> EN (Tarih & Arkeoloji)
  const TranslationDrill(
    id: 'tr_02',
    direction: TranslationDirection.turkishToEnglish,
    topic: 'Tarih & Arkeoloji',
    originalSentence:
        'Güneydoğu Anadolu\'da yer alan Göbeklitepe, avcı-toplayıcı toplulukların tarıma geçmeden önce anıtsal yapılar inşa edebildiğini kanıtlayarak insanlık tarihi hakkındaki yerleşik kabulleri kökten değiştirmiştir.',
    components: [
      SentenceComponent(
        label: 'Özne + Sıfat Grubu (Subject)',
        text: 'Güneydoğu Anadolu\'da yer alan Göbeklitepe (Göbeklitepe, located in southeastern Anatolia)',
        roleCode: 'subject',
      ),
      SentenceComponent(
        label: 'Zarf Fiil Grubu (By proving that...)',
        text: 'avcı-toplayıcı toplulukların tarıma geçmeden önce anıtsal yapılar inşa edebildiğini kanıtlayarak',
        roleCode: 'clause',
      ),
      SentenceComponent(
        label: 'Nesne (Object)',
        text: 'insanlık tarihi hakkındaki yerleşik kabulleri (established assumptions about human history)',
        roleCode: 'object',
      ),
      SentenceComponent(
        label: 'Ana Yüklem (Main Verb - Present Perfect)',
        text: 'kökten değiştirmiştir (has fundamentally changed / altered)',
        roleCode: 'verb',
      ),
    ],
    options: [
      'A) Göbeklitepe, which is situated in southeastern Anatolia, was able to construct monumental structures before hunter-gatherers transitioned to agriculture, radically altering human history.',
      'B) Located in southeastern Anatolia, Göbeklitepe has fundamentally changed established assumptions about human history by proving that hunter-gatherer communities were able to build monumental structures before transitioning to agriculture.',
      'C) Hunter-gatherer communities in southeastern Anatolia fundamentally changed assumptions about human history by building monumental structures at Göbeklitepe before they began agriculture.',
      'D) Proving that hunter-gatherers could build monuments prior to agriculture, Göbeklitepe in southeastern Anatolia will change established beliefs regarding the history of humanity.',
      'E) Established assumptions about human history have been radically altered by Göbeklitepe, which proved that hunter-gatherers in southeastern Anatolia built monumental buildings after agriculture.',
    ],
    correctIndex: 1,
    distractorAnalysis: {
      0: 'A şıkkında Göbeklitepe\'nin kendisi anıtsal yapı inşa etmiş gibi gösterilmiş, özne-eylem mantığı bozulmuştur.',
      1: 'DOĞRU CEVAP: "Located in southeastern Anatolia (Güneydoğu Anadolu\'da yer alan)", özne "Göbeklitepe", yüklem "has fundamentally changed (kökten değiştirmiştir)", zarf "by proving that... (kanıtlayarak)". Kusursuz eşleşme.',
      2: 'C şıkkında ana özne "Göbeklitepe" yerine "Hunter-gatherer communities" yapılmıştır.',
      3: 'D şıkkında yüklem "will change (değiştirecektir)" şeklinde gelecek zamana çekimlenmiştir, oysa Türkçe metin "değiştirmiştir (has changed)".',
      4: 'E şıkkında edilgen yapı kullanılmış ve "after agriculture (tarımdan sonra)" denilerek anlam 180 derece tersine çevrilmiştir.',
    },
    goldenRule:
        'ÖSYM TR-EN Çeviri Altın Kuralı: Türkçe cümlenin sonundaki yüklemi bulun ("kökten değiştirmiştir" -> "has fundamentally changed/altered"). Gelecek zaman ("will change") veya geçmiş zaman ("was able to") diyen seçenekleri doğrudan eleyin!',
    fullTranslation:
        'Located in southeastern Anatolia, Göbeklitepe has fundamentally changed established assumptions about human history by proving that hunter-gatherer communities were able to build monumental structures before transitioning to agriculture.',
  ),

  // 3. EN -> TR (Çevre & İklim)
  const TranslationDrill(
    id: 'tr_03',
    direction: TranslationDirection.englishToTurkish,
    topic: 'Çevre & İklim Değişikliği',
    originalSentence:
        'Unless governments around the world implement stringent carbon emission policies immediately, the irreversible melting of polar ice caps will trigger catastrophic rises in global sea levels within the next few decades.',
    components: [
      SentenceComponent(
        label: 'Şart Cümleciği (Condition Clause - Unless)',
        text: 'Unless governments around the world implement stringent carbon emission policies immediately',
        roleCode: 'clause',
      ),
      SentenceComponent(
        label: 'Ana Cümlenin Öznesi (Subject)',
        text: 'the irreversible melting of polar ice caps',
        roleCode: 'subject',
      ),
      SentenceComponent(
        label: 'Ana Yüklem (Main Verb - Future)',
        text: 'will trigger',
        roleCode: 'verb',
      ),
      SentenceComponent(
        label: 'Nesne ve Zaman Zarfı (Object & Time)',
        text: 'catastrophic rises in global sea levels within the next few decades',
        roleCode: 'object',
      ),
    ],
    options: [
      'A) Dünya genelindeki hükümetler katı karbon salınımı politikalarını derhal uygulamadıkça, kutup buzullarının geri dönüşü olmayan erimesi önümüzdeki birkaç on yıl içinde küresel deniz seviyelerinde felaket boyutunda artışları tetikleyecektir.',
      'B) Eğer dünya çapındaki hükümetler karbon salınımına dair katı politikalar uygulamazlarsa, kutup buzulları eriyecek ve deniz seviyelerindeki yıkıcı artışlar birkaç on yıl sürecektir.',
      'C) Önümüzdeki birkaç on yıl içinde küresel deniz seviyelerinin felaket derecesinde yükselmesini engellemek için tüm hükümetlerin katı karbon emisyon kurallarını derhal hayata geçirmesi gerekmektedir.',
      'D) Kutup buzullarının geri dönülemez biçimde erimesi sonucu dünya genelinde hükümetler katı önlemler alsa bile küresel deniz seviyelerinde yıkıcı yükselişler meydana gelebilir.',
      'E) Dünya hükümetleri derhal katı politikalar uygulasa dahi kutup buzulları erimeye devam edecek ve bu durum deniz seviyelerinde felaket artışlarına yol açacaktır.',
    ],
    correctIndex: 0,
    distractorAnalysis: {
      0: 'DOĞRU CEVAP: "Unless... uygulamadıkça / -medikçe", özne "kutup buzullarının geri dönüşü olmayan erimesi", yüklem "tetikleyecektir (will trigger)". Bütün ögeler ve zaman kipi tam uyuşmaktadır.',
      1: 'B şıkkında "Unless" koşulu ve cümle yapısı parçalanmış, "birkaç on yıl sürecektir" denilerek zaman zarfı yanlış bağlanmıştır.',
      2: 'C şıkkında amaç cümlesi yapılmış ("engellemek için... gerekmektedir"), metindeki şart ve gelecek zaman yüklemi kaybolmuştur.',
      3: 'D şıkkında "alsa bile" ve "meydana gelebilir (may happen)" denilerek olasılık eklenmiştir.',
      4: 'E şıkkında "Even if" (olsa dahi) anlamı yüklenmiş, "Unless" olumsuz koşulu çarpıtılmıştır.',
    },
    goldenRule:
        'ÖSYM Bağlaç Çeviri Taktikleri: "Unless" yapısı Türkçede genellikle "-medikçe / -madıkça" veya "eğer ... -mezse" olarak karşılanır. Seçeneklerde "alsa bile" veya "engellemek amacıyla" gibi farklı bağlaç karşılıkları olanları hemen eleyin.',
    fullTranslation:
        'Dünya genelindeki hükümetler katı karbon salınımı politikalarını derhal uygulamadıkça, kutup buzullarının geri dönüşü olmayan erimesi önümüzdeki birkaç on yıl içinde küresel deniz seviyelerinde felaket boyutunda artışları tetikleyecektir.',
  ),

  // 4. TR -> EN (Psikoloji & Sosyoloji)
  const TranslationDrill(
    id: 'tr_04',
    direction: TranslationDirection.turkishToEnglish,
    topic: 'Psikoloji & Davranış Bilimleri',
    originalSentence:
        'Sosyal medyanın bilinçsiz kullanımı, özellikle ergenler arasında kaygı ve yalnızlık duygularını artırmakla kalmayıp bireylerin yüz yüze iletişim kurma becerilerini de ciddi biçimde zayıflatmaktadır.',
    components: [
      SentenceComponent(
        label: 'Özne (Subject)',
        text: 'Sosyal medyanın bilinçsiz kullanımı (The unconscious / mindless use of social media)',
        roleCode: 'subject',
      ),
      SentenceComponent(
        label: 'Zarf Grubu (Particularly among adolescents)',
        text: 'özellikle ergenler arasında',
        roleCode: 'clause',
      ),
      SentenceComponent(
        label: 'Kalıp İfade (Not only ... but also ...)',
        text: 'kaygı ve yalnızlık duygularını artırmakla kalmayıp ... becerilerini de zayıflatmaktadır',
        roleCode: 'verb',
      ),
      SentenceComponent(
        label: 'Nesne & Zarf (Severely impairs individuals\' skills...)',
        text: 'bireylerin yüz yüze iletişim kurma becerilerini de ciddi biçimde',
        roleCode: 'object',
      ),
    ],
    options: [
      'A) Unconscious social media usage leads to feelings of anxiety and loneliness in adolescents, so they gradually lose their face-to-face communication abilities.',
      'B) The mindless use of social media not only increases feelings of anxiety and loneliness, particularly among adolescents, but it also severely weakens individuals’ face-to-face communication skills.',
      'C) If adolescents use social media mindlessly, their feelings of anxiety and isolation will intensify along with a severe reduction in communicative skills.',
      'D) Mindless social media engagement is believed to increase loneliness in teenagers while completely destroying their personal communication talents.',
      'E) Not only face-to-face communication skills are undermined by social media, but also anxiety and depression are fostered among young generations.',
    ],
    correctIndex: 1,
    distractorAnalysis: {
      0: 'A şıkkında "...ile sonuçlanır, bu yüzden..." (so) bağlacı kullanılmış, "not only ... but also" kalıbı yok sayılmıştır.',
      1: 'DOĞRU CEVAP: "The mindless use of social media (Özne)", "not only increases ... but also severely weakens (kalıp yüklem)", "face-to-face communication skills (nesne)". Kusursuz ÖSYM çevirisi.',
      2: 'C şıkkında "If" şart cümlesine çevrilmiş, cümlenin orijinal yapısı bozulmuştur.',
      3: 'D şıkkında "is believed to (inanılmaktadır)" ve "completely destroying (tamamen yok eden)" gibi metinde olmayan ifadeler eklenmiştir.',
      4: 'E şıkkında devrik yapı nesneye kaydırılmış ve özne-yüklem dengesi altüst edilmiştir.',
    },
    goldenRule:
        'ÖSYM Kalıp Çeviri Kuralı: "...-makla kalmayıp ... da" yapısının İngilizce karşılığı daima "not only ... but also ..." veya "not merely ... but as well" kalıbıdır. Bu kalıbı içermeyen seçenekleri doğrudan eleyin!',
    fullTranslation:
        'The mindless use of social media not only increases feelings of anxiety and loneliness, particularly among adolescents, but it also severely weakens individuals’ face-to-face communication skills.',
  ),

  // 5. EN -> TR (Teknoloji & Yapay Zeka)
  const TranslationDrill(
    id: 'tr_05',
    direction: TranslationDirection.englishToTurkish,
    topic: 'Yapay Zekâ & Teknoloji',
    originalSentence:
        'Artificial intelligence systems, which are increasingly deployed in medical diagnostics, can analyze thousands of radiographic images in seconds, thereby helping physicians detect anomalies that might otherwise be overlooked.',
    components: [
      SentenceComponent(
        label: 'Özne + Sıfat Cümleciği (Subject + Non-defining Relative Clause)',
        text: 'Artificial intelligence systems, which are increasingly deployed in medical diagnostics',
        roleCode: 'subject',
      ),
      SentenceComponent(
        label: 'Ana Yüklem (Modal + Verb)',
        text: 'can analyze',
        roleCode: 'verb',
      ),
      SentenceComponent(
        label: 'Nesne & Zaman (Object & Time)',
        text: 'thousands of radiographic images in seconds',
        roleCode: 'object',
      ),
      SentenceComponent(
        label: 'Sonuç & Tarz Cümleciği (Thereby helping... + that clause)',
        text: 'thereby helping physicians detect anomalies that might otherwise be overlooked',
        roleCode: 'clause',
      ),
    ],
    options: [
      'A) Tıbbi teşhislerde giderek daha fazla kullanılan yapay zekâ sistemleri, binlerce radyografik görüntüyü saniyeler içinde analiz edebilmekte ve böylece hekimlerin aksi takdirde gözden kaçabilecek anomalileri tespit etmelerine yardımcı olmaktadır.',
      'B) Hekimlerin gözden kaçırabileceği anomalileri tespit etmek amacıyla tıbbi teşhislerde kullanılan yapay zekâ, binlerce görüntüyü çok hızlı bir şekilde analiz edebilir.',
      'C) Yapay zekâ sistemleri tıp alanında o kadar hızlı yaygınlaşmıştır ki hekimlerin tespit edemediği radyografik anomalileri saniyeler içinde analiz ederek çözmektedir.',
      'D) Tıbbi teşhislerde hekimlerin yardımıyla kullanılan yapay zekâ, aksi halde gözden kaçacak olan radyografik görüntüleri saniyeler içinde tespit etmeyi hedeflemektedir.',
      'E) Binlerce radyografik görüntünün saniyeler içinde analiz edilmesi, tıbbi teşhiste yapay zekâ kullanımını artırmış ve hekimlerin anomalileri daha rahat görmesini sağlamıştır.',
    ],
    correctIndex: 0,
    distractorAnalysis: {
      0: 'DOĞRU CEVAP: "which are increasingly deployed... giderek daha fazla kullanılan", ana özne "yapay zekâ sistemleri", yüklemler "...analiz edebilmekte ve böylece ... yardımcı olmaktadır", "that might otherwise be overlooked... aksi takdirde gözden kaçabilecek". Tam uyum.',
      1: 'B şıkkında amaç cümlesi yapılmış ("amacıyla"), "thereby" sonucu kaybolmuş ve özne sıfat cümleciği deforme edilmiştir.',
      2: 'C şıkkında "o kadar ... ki (so ... that)" sonucu uydurulmuş, "can analyze" yetenek kipi atlanmıştır.',
      3: 'D şıkkında "hekimlerin yardımıyla" denilerek anlam tersyüz edilmiştir (yapay zeka hekime yardım ediyor, hekim yapay zekaya değil).',
      4: 'E şıkkında özne "analiz edilmesi (gerund)" yapılarak cümlenin bütün yapısı bozulmuştur.',
    },
    goldenRule:
        'ÖSYM Sıfat Cümleciği & Çeviri Kuralı: "which are deployed... kullanılan" sıfat-fiil olarak öznenin başına gelir. "thereby + Ving" ise Türkçede daima "böylece / bu sayede ... -erek / yardımcı olmaktadır" şeklinde karşılanır.',
    fullTranslation:
        'Tıbbi teşhislerde giderek daha fazla kullanılan yapay zekâ sistemleri, binlerce radyografik görüntüyü saniyeler içinde analiz edebilmekte ve böylece hekimlerin aksi takdirde gözden kaçabilecek anomalileri tespit etmelerine yardımcı olmaktadır.',
  ),
];
