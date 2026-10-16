import '../models/question.dart';

final List<Question> defaultSeedQuestions = [
  // ================= 1. KELİME BİLGİSİ (VOCABULARY) =================
  const Question(
    id: 'q_voc_1',
    category: QuestionCategory.vocabulary,
    questionText:
        'Scientists are actively seeking alternative energy solutions to ---- the damaging effects of fossil fuel dependency on atmospheric equilibrium.',
    options: [
      'A) aggravate',
      'B) mitigate',
      'C) duplicate',
      'D) anticipate',
      'E) propagate',
    ],
    correctIndex: 1, // B) mitigate
    explanation:
        'DOĞRU CEVAP: B) mitigate (hafifletmek, azaltmak).\n\n'
        'Cümle Analizi:\n'
        '"Bilim insanları, fosil yakıt bağımlılığının atmosfer dengesi üzerindeki zararlı etkilerini hafifletmek / azaltmak (mitigate) için aktif olarak alternatif enerji çözümleri aramaktadır."\n\n'
        'Çeldiriciler:\n'
        '• aggravate: kötüleştirmek, şiddetlendirmek\n'
        '• duplicate: kopyalamak, çoğaltmak\n'
        '• anticipate: önceden tahmin etmek, beklemek\n'
        '• propagate: yaymak, çoğalmak\n\n'
        'Zararlı etkileri hafifletme bağlamında "mitigate the effects" en yaygın akademik YDS kalıbıdır.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),
  const Question(
    id: 'q_voc_2',
    category: QuestionCategory.vocabulary,
    questionText:
        'Recent macroeconomic data indicates that consumer spending and private investments ---- more than sixty percent of the national gross domestic product.',
    options: [
      'A) call off',
      'B) look down on',
      'C) account for',
      'D) take after',
      'E) put up with',
    ],
    correctIndex: 2, // C) account for
    explanation:
        'DOĞRU CEVAP: C) account for (oluşturmak, tekabül etmek).\n\n'
        'Cümle Analizi:\n'
        '"Son makroekonomik veriler, tüketici harcamaları ve özel yatırımların milli gayrisafi yurt içi hasılanın yüzde altmışından fazlasını oluşturduğunu (account for) göstermektedir."\n\n'
        'Çeldiriciler:\n'
        '• call off: iptal etmek\n'
        '• look down on: küçümsemek, hor görmek\n'
        '• take after: birine benzemek (aile büyüğüne)\n'
        '• put up with: katlanmak, tahammül etmek\n\n'
        'YDS\'de "account for + yüzde/oran/miktar" yapısı istisnasız en sık karşılaşılan phrasal verb kalıbıdır.',
    difficulty: 'İleri',
    isPremiumOnly: false,
  ),
  const Question(
    id: 'q_voc_3',
    category: QuestionCategory.vocabulary,
    questionText:
        'Repeated failures in regulatory oversight have severely ---- public trust in the integrity of the banking system.',
    options: [
      'A) bolstered',
      'B) undermined',
      'C) fostered',
      'D) cherished',
      'E) reiterated',
    ],
    correctIndex: 1, // B) undermined
    explanation:
        'DOĞRU CEVAP: B) undermined (baltalamak, zayıflatmak, temelini sarsmak).\n\n'
        'Cümle Anlamı:\n'
        'Denetim ve gözetim mekanizmasındaki tekrarlayan başarısızlıklar, halkın bankacılık sisteminin dürüstlüğüne olan güvenini ciddi biçimde sarsmıştır / baltalamıştır.\n\n'
        '• bolstered: güçlendirilmiş, desteklenmiş\n'
        '• fostered: teşvik edilmiş, büyütülmüş\n'
        '• cherished: değer verilmiş, bağra basılmış\n'
        '• reiterated: yinelenmiş, tekrar edilmiş',
    difficulty: 'İleri',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_voc_4',
    category: QuestionCategory.vocabulary,
    questionText:
        'The pharmaceutical company made a substantial financial investment in biotechnology to discover a drug that could permanently ---- congenital cardiac disorders.',
    options: [
      'A) eradicate',
      'B) perpetuate',
      'C) stimulate',
      'D) complicate',
      'E) accelerate',
    ],
    correctIndex: 0, // A) eradicate
    explanation:
        'DOĞRU CEVAP: A) eradicate (kökünü kazımak, tamamen yok etmek).\n\n'
        'İlaç şirketinin konjenital kalp rahatsızlıklarını tamamen ortadan kaldırma / kökünü kurutma (eradicate) amacıyla yatırım yaptığı ifade edilmektedir.\n'
        '• perpetuate: sürdürmek, ebedileştirmek\n'
        '• stimulate: uyarmak, canlandırmak\n'
        '• complicate: karmaşıklaştırmak\n'
        '• accelerate: hızlandırmak',
    difficulty: 'İleri',
    isPremiumOnly: false,
  ),

  // ================= 2. GRAMER & DİLBİLGİSİ (GRAMMAR) =================
  const Question(
    id: 'q_gram_1',
    category: QuestionCategory.grammar,
    questionText:
        '---- several international treaties have banned the discharge of toxic industrial waste into international waters, many corporations continue to bypass surveillance systems.',
    options: [
      'A) Although',
      'B) Because',
      'C) In case',
      'D) Unless',
      'E) Provided that',
    ],
    correctIndex: 0, // A) Although
    explanation:
        'DOĞRU CEVAP: A) Although (Her ne kadar ... -se de, -e rağmen).\n\n'
        'Zıtlık Analizi:\n'
        'İlk cümlede uluslararası anlaşmaların zehirli atıkların boşaltılmasını "yasaklaması" (banned), ikinci cümlede ise birçok şirketin gözetim sistemlerini "delmeye/atlatmaya devam etmesi" (continue to bypass) anlatılmaktadır.\n'
        'Bu iki yargı arasında belirgin bir tezat / zıtlık ilişkisi olduğundan zıtlık bildiren bağlaç olan "Although" kullanılır.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),
  const Question(
    id: 'q_gram_2',
    category: QuestionCategory.grammar,
    questionText:
        'By the time the diplomatic summit ---- in Geneva next month, key delegates ---- on all fundamental clauses of the climate accord.',
    options: [
      'A) convenes / will have agreed',
      'B) convened / had agreed',
      'C) will convene / agree',
      'D) had convened / would agree',
      'E) convenes / will be agreeing',
    ],
    correctIndex: 0, // A) convenes / will have agreed
    explanation:
        'DOĞRU CEVAP: A) convenes / will have agreed.\n\n'
        'Zaman Uyumu Kuralı (By the time):\n'
        '"By the time" kuralına göre, eğer geleceğe yönelik bir ifade ("next month") varsa:\n'
        'By the time + Simple Present (convenes), Future Perfect (will have agreed)\n'
        'Anlam: Gelecek ay Cenevre\'de zirve toplanana KADAR, delegeler anlaşmanın tüm maddelerinde uzlaşmış OLACAKLAR.',
    difficulty: 'İleri',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_gram_3',
    category: QuestionCategory.grammar,
    questionText:
        'Severe volcanic eruptions not only release monumental plumes of ash into the stratosphere, ---- they can also induce temporary global cooling by reflecting solar radiation.',
    options: [
      'A) but',
      'B) nor',
      'C) so',
      'D) yet',
      'E) as',
    ],
    correctIndex: 0, // A) but
    explanation:
        'DOĞRU CEVAP: A) but (not only ... but also kalıbı).\n\n'
        '"Not only ... but also" yapısı "Sadece ... değil, aynı zamanda ..." anlamına gelen paralel ikili bir bağlaçtır.\n'
        'Cümlede "not only" kullanıldığı için ikinci kısımda "but (they can also)" gelmelidir.',
    difficulty: 'Kolay',
    isPremiumOnly: false,
  ),

  // ================= 3. CÜMLE TAMAMLAMA (SENTENCE COMPLETION) =================
  const Question(
    id: 'q_sent_1',
    category: QuestionCategory.sentenceCompletion,
    questionText:
        'Owing to unprecedented warming trends documented in Arctic regions, ----.',
    options: [
      'A) local wildlife populations have expanded their habitats towards southern latitudes',
      'B) permafrost thaw is accelerating, releasing previously trapped greenhouse gases into the atmosphere',
      'C) climate scientists had predicted that polar ice caps would never melt before the end of the century',
      'D) renewable energy costs have plummeted dramatically across industrialized nations',
      'E) many coastal cities around the world were already fortified against storm surges in the nineteenth century',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        'Sebep-Sonuç İlişkisi (Owing to = -den dolayı):\n'
        '"Kutup bölgelerinde belgelenen eşi benzeri görülmemiş ısınma eğilimleri nedeniyle..." ifadesinin doğal ve mantıklı sonucu, donmuş toprak tabakasının (permafrost) erimesi ve hapsolmuş sera gazlarının atmosfere salınmasıdır.\n'
        'C ve E şıklarındaki geçmiş zaman (had predicted / were fortified) zaman uyumunu bozar.',
    difficulty: 'İleri',
    isPremiumOnly: false,
  ),
  const Question(
    id: 'q_sent_2',
    category: QuestionCategory.sentenceCompletion,
    questionText:
        'Whereas developed nations are investing billions into transition technologies, ----.',
    options: [
      'A) they have completely phased out the consumption of coal and petroleum',
      'B) many developing countries lack the fiscal capacity to upgrade their conventional energy grids',
      'C) solar panels are becoming progressively more affordable for domestic consumers',
      'D) public health expenditures have doubled in the past two decades',
      'E) international climate summits are scheduled every four years',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        '"Whereas" (oysa ki, -e karşılık) bağlacı taban tabana zıt iki özne veya durumu karşılaştırır.\n'
        'Gelişmiş ülkelerin milyarlarca dolar yatırım yapmasına ("developed nations are investing billions") karşılık, gelişmekte olan pek çok ülkenin mali kapasiteden yoksun olması ("developing countries lack fiscal capacity") kusursuz bir zıtlık oluşturur.',
    difficulty: 'Orta',
    isPremiumOnly: true,
  ),

  // ================= 4. İNGİLİZCE - TÜRKÇE ÇEVİRİ =================
  const Question(
    id: 'q_tr_1',
    category: QuestionCategory.translationEnTr,
    questionText:
        'Artificial intelligence models trained on vast datasets can detect subtle patterns that human observers often fail to notice.',
    options: [
      'A) İnsan gözlemcilerin dikkatinden kaçan ayrıntıları yakalamak için yapay zeka modelleri devasa veri kümeleriyle eğitilmektedir.',
      'B) Devasa veri kümeleri üzerinde eğitilen yapay zeka modelleri, insan gözlemcilerin çoğunlukla fark edemediği ince örüntüleri tespit edebilir.',
      'C) Yapay zeka modellerinin ince örüntüleri fark edebilmesi, yalnızca devasa veri kümeleriyle eğitilmelerine bağlıdır.',
      'D) İnsan gözlemcilerin göremediği incelikleri yakalayan yapay zeka modelleri, çok büyük veri setlerine dayanır.',
      'E) Devasa veri kümeleriyle eğitilseler bile yapay zeka modelleri, insan gözlemcilerin bulamadığı örüntüleri nadiren tespit edebilir.',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        'Özne ve Yüklem Analizi:\n'
        '• Özne: "Artificial intelligence models trained on vast datasets" -> "Devasa veri kümeleri üzerinde eğitilen yapay zeka modelleri"\n'
        '• Yüklem: "can detect subtle patterns..." -> "...ince örüntüleri tespit edebilir."\n'
        '• Sıfat Cümlesi: "...that human observers often fail to notice" -> "...insan gözlemcilerin çoğunlukla fark edemediği"\n'
        'B şıkkı cümlenin tüm ögelerini ve "can" modalını tam karşılar.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),
  const Question(
    id: 'q_tr_3',
    category: QuestionCategory.translationEnTr,
    questionText:
        'Unless educational systems adapt to the demands of the digital age, future generations will struggle to secure meaningful employment.',
    options: [
      'A) Eğitim sistemleri dijital çağın gereklerine uyum sağlamadıkça, gelecek nesiller anlamlı bir iş bulmakta zorlanacaktır.',
      'B) Gelecek nesillerin anlamlı bir istihdam elde edebilmesi, eğitim sistemlerinin dijitalleşmesine bağlıdır.',
      'C) Dijital çağın taleplerine hızla uyum sağlayan eğitim sistemleri, yeni nesillere daha iyi iş imkanları sunar.',
      'D) Eğitim sistemleri çağa ayak uydursa bile, gelecekte istihdam olanakları giderek daralacaktır.',
      'E) Yeni nesillerin iş bulma güçlüğü, ancak dijital eğitim sistemlerinin geliştirilmesiyle aşılabilir.',
    ],
    correctIndex: 0, // A
    explanation:
        'DOĞRU CEVAP: A\n\n'
        '• "Unless" bağlacı "-medikçe / -mezse" olumsuz koşul anlamı verir.\n'
        '• "Unless educational systems adapt..." -> "Eğitim sistemleri uyum sağlamadıkça..."\n'
        '• "...future generations will struggle to secure..." -> "...gelecek nesiller elde etmekte/bulmakta zorlanacaktır."',
    difficulty: 'Orta',
    isPremiumOnly: true,
  ),

  // ================= 5. TÜRKÇE - İNGİLİZCE ÇEVİRİ =================
  const Question(
    id: 'q_tr_2',
    category: QuestionCategory.translationTrEn,
    questionText:
        'Beynin yeni anılar oluşturma ve bilgiyi işleme kapasitesi, uyku kalitesinden doğrudan etkilenmektedir.',
    options: [
      'A) Sleep quality is largely determined by the brain\'s efficiency in generating new memories and processing information.',
      'B) The brain\'s capacity to form new memories and process information is directly influenced by sleep quality.',
      'C) When sleep quality deteriorates, the brain can no longer retain information or form long-term memories.',
      'D) The capacity of the human brain to process new information depends entirely on uninterrupted sleep patterns.',
      'E) Quality sleep directly enhances how the brain creates memories and synthesizes complex data.',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        'Özne-Yüklem Eşleşmesi:\n'
        '• Türkçe Özne: "Beynin yeni anılar oluşturma ve bilgiyi işleme kapasitesi" -> "The brain\'s capacity to form new memories and process information"\n'
        '• Türkçe Yüklem (Edilgen): "...uyku kalitesinden doğrudan etkilenmektedir." -> "...is directly influenced by sleep quality."\n'
        'Bu yapı birebir B şıkkında pasif çatı (is directly influenced) ile verilmiştir.',
    difficulty: 'Orta',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_tr_4',
    category: QuestionCategory.translationTrEn,
    questionText:
        'Hükümet, yerel üreticileri desteklemek amacıyla tarımsal sübvansiyonları artırma kararı almıştır.',
    options: [
      'A) The government decided to enhance agricultural subsidies in order to support domestic producers.',
      'B) Domestic producers demanded that the government allocate more agricultural funds to regional projects.',
      'C) In supporting agricultural subsidies, the government enabled domestic farmers to survive.',
      'D) The decision to support local farmers caused the government to reduce municipal spending.',
      'E) Increasing subsidies for local producers was considered the most viable economic alternative.',
    ],
    correctIndex: 0, // A
    explanation:
        'DOĞRU CEVAP: A\n\n'
        '• Özne: The government (Hükümet)\n'
        '• Yüklem: decided to enhance agricultural subsidies (tarımsal sübvansiyonları artırma kararı almıştır)\n'
        '• Amaç bildiren zarf tümleci: in order to support domestic producers (yerel üreticileri desteklemek amacıyla)',
    difficulty: 'Kolay',
    isPremiumOnly: false,
  ),

  // ================= 6. PARAGRAF & OKUMA PARÇASI =================
  const Question(
    id: 'q_read_1',
    category: QuestionCategory.reading,
    passage:
        'The discovery of deep-sea hydrothermal vents in 1977 revolutionized our understanding of life\'s fundamental requirements. Previously, biologists held the firm belief that sunlight was the indispensable energy engine of all ecosystems via photosynthesis. However, these abyssal ecosystems flourish around fissures in the ocean floor where scalding, mineral-laden fluids emerge, completely cut off from solar radiation. In these extreme environments, specialized bacteria exploit chemosynthesis—converting chemical compounds like hydrogen sulfide into organic matter. This finding not only transformed terrestrial biology but also expanded the horizon of astrobiology, suggesting that life could conceivably thrive in the sunless subterranean oceans of icy moons such as Europa and Enceladus.',
    questionText:
        'According to the passage, the discovery of hydrothermal vents challenged previous scientific views because ----.',
    options: [
      'A) it demonstrated that sunlight is not a mandatory prerequisite for sustaining complex ecosystems',
      'B) deep-sea creatures were found to possess photosynthetic mechanisms identical to terrestrial plants',
      'C) ocean floor temperatures were revealed to be significantly colder than previously calculated',
      'D) bacteria in hydrothermal vents were incapable of producing organic compounds',
      'E) it proved that all living organisms primarily rely on hydrogen sulfide for survival',
    ],
    correctIndex: 0, // A
    explanation:
        'DOĞRU CEVAP: A\n\n'
        'Metinde açıkça belirtilmektedir:\n'
        '"Previously, biologists held the firm belief that sunlight was the indispensable energy engine... However, these abyssal ecosystems flourish... completely cut off from solar radiation."\n'
        'Güneş ışığının tüm yaşam için zorunlu bir önkoşul olmadığını ("not a mandatory prerequisite") kanıtlamıştır.',
    difficulty: 'İleri',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_read_2',
    category: QuestionCategory.reading,
    passage:
        'The discovery of deep-sea hydrothermal vents in 1977 revolutionized our understanding of life\'s fundamental requirements. Previously, biologists held the firm belief that sunlight was the indispensable energy engine of all ecosystems via photosynthesis. However, these abyssal ecosystems flourish around fissures in the ocean floor where scalding, mineral-laden fluids emerge, completely cut off from solar radiation. In these extreme environments, specialized bacteria exploit chemosynthesis—converting chemical compounds like hydrogen sulfide into organic matter. This finding not only transformed terrestrial biology but also expanded the horizon of astrobiology, suggesting that life could conceivably thrive in the sunless subterranean oceans of icy moons such as Europa and Enceladus.',
    questionText:
        'It can be inferred from the passage that astrobiologists find hydrothermal vents significant because ----.',
    options: [
      'A) moons like Europa and Enceladus receive extensive solar energy identical to Earth',
      'B) conditions around these ocean vents provide a plausible model for potential life in extraterrestrial dark oceans',
      'C) all deep-sea bacteria originally migrated from outer space to Earth',
      'D) the mineral content of Europa\'s crust is identical to terrestrial ocean trenches',
      'E) hydrothermal vents are easily observable through optical telescopes from Earth',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        'Metnin son cümlesinde: "...suggesting that life could conceivably thrive in the sunless subterranean oceans of icy moons such as Europa and Enceladus." ifadesi yer almaktadır.\n'
        'Yani vents ekosistemi, güneş görmeyen uzay okyanuslarında yaşamın var olabileceğine dair inandırıcı bir model sunmaktadır.',
    difficulty: 'İleri',
    isPremiumOnly: true,
  ),

  // ================= 7. DİYALOG TAMAMLAMA (DIALOGUE COMPLETION) =================
  const Question(
    id: 'q_dial_1',
    category: QuestionCategory.dialogue,
    questionText:
        'Professor Jenkins: Have you reviewed the laboratory data regarding the new catalytic enzyme?\n\n'
        'Dr. Miller: Yes, the reaction velocity exceeded our baseline projections by almost thirty percent.\n\n'
        'Professor Jenkins: ----\n\n'
        'Dr. Miller: Absolutely. We ran the assay three consecutive times with identical controls to rule out contamination.',
    options: [
      'A) Why didn\'t you invite the graduate students to observe the initial reaction?',
      'B) But can we be entirely confident that the accelerated rate wasn\'t caused by an experimental artifact?',
      'C) Did you remember to calibrate the temperature sensors before the experiment?',
      'D) I believe we should immediately file a commercial patent application.',
      'E) How much funding do we have left in this fiscal quarter?',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        'Bağlam Takibi:\n'
        'Dr. Miller\'ın yanıtı: "Kesinlikle. Bulaşma ihtimalini elemek (rule out contamination) için testi özdeş kontrollerle üç kez art arda çalıştırdık."\n'
        'Bu yanıt, Profesör Jenkins\'in hızlanmanın bir hata ya da yapay etkenden kaynaklanıp kaynaklanmadığına dair şüphesine ("wasn\'t caused by an experimental artifact") verilmiş mükemmel bir cevaptır.',
    difficulty: 'İleri',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_dial_2',
    category: QuestionCategory.dialogue,
    questionText:
        'Sarah: Many analysts believe remote working will diminish collaborative innovation over time.\n\n'
        'Mark: ----\n\n'
        'Sarah: Exactly. With asynchronous whiteboards and instant virtual rooms, teams often communicate more purposefully than when sitting in open-plan offices.',
    options: [
      'A) I couldn\'t disagree more; digital collaboration tools have actually streamlined how teams exchange creative ideas.',
      'B) In fact, remote working has increased commuting expenses for suburban employees.',
      'C) Corporate managers are ordering all personnel to return to physical desks full-time.',
      'D) Productivity usually plummets whenever employees are unsupervised.',
      'E) Video conferences are notoriously inefficient for resolving technical bottlenecks.',
    ],
    correctIndex: 0, // A
    explanation:
        'DOĞRU CEVAP: A\n\n'
        'Sarah\'nın son cümlesinde "Exactly" (Kesinlikle/Aynen öyle) diyerek Mark\'ın fikrini desteklemesi ve dijital araçların açık ofislerden daha amaçlı iletişimi sağladığını söylemesi, Mark\'ın uzaktan çalışmanın iş birliğini öldürmediğini savunan A şıkkını söylediğini kanıtlar.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),

  // ================= 8. YAKIN ANLAMLI CÜMLE (RESTATEMENT) =================
  const Question(
    id: 'q_rest_1',
    category: QuestionCategory.restatement,
    questionText:
        'Had the government intervened earlier with emergency fiscal subsidies, many small enterprises could have survived the economic downturn.',
    options: [
      'A) Small businesses would have collapsed regardless of whether the government provided monetary assistance or not.',
      'B) The government intervened promptly, which enabled the majority of small enterprises to withstand the recession.',
      'C) Since the government delayed providing financial assistance, numerous small businesses were unable to survive the recession.',
      'D) Emergency subsidies were distributed to small enterprises too late, yet none of them had to declare bankruptcy.',
      'E) The survival of small businesses was entirely independent of any governmental fiscal decisions.',
    ],
    correctIndex: 2, // C
    explanation:
        'DOĞRU CEVAP: C\n\n'
        'Devrik Şart Cümlesi (Inverted Condition - Type 3):\n'
        '"Had the government intervened earlier..." = Hükümet daha erken mali yardım sağlasaydı pek çok işletme hayatta kalabilirdi.\n'
        'Gerçek durum: Hükümet gecikti, bu yüzden birçok işletme battı.\n'
        'Bu anlamı birebir C şıkkı verir: "Since the government delayed providing financial assistance, numerous small businesses were unable to survive the recession."',
    difficulty: 'İleri',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_rest_2',
    category: QuestionCategory.restatement,
    questionText:
        'No sooner had the archeological team unsealed the burial vault than fragile murals began to deteriorate from exposure to ambient humidity.',
    options: [
      'A) The burial chamber was sealed again immediately because the frescoes showed signs of age-related wear.',
      'B) As soon as the tomb was opened by the archeologists, moisture in the air started to damage the delicate wall paintings.',
      'C) Although humidity ruined some wall paintings, archeologists successfully protected the primary chamber artifacts.',
      'D) The wall paintings were already severely decayed long before the archeological team arrived at the tomb.',
      'E) Opening the burial chamber helped prevent humid air from destroying ancient frescoes.',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        '"No sooner ... than ..." kalıbı "yapar yapmaz / -mesiyle -mesi bir oldu" (as soon as) anlamındadır.\n'
        'Mezar odası açılır açılmaz hassas duvar resimleri havadaki nemden ötürü bozulmaya başladı anlamını tam olarak B şıkkı verir.',
    difficulty: 'İleri',
    isPremiumOnly: false,
  ),

  // ================= 9. PARAGRAF TAMAMLAMA (PARAGRAPH COMPLETION) =================
  const Question(
    id: 'q_par_1',
    category: QuestionCategory.paragraphCompletion,
    questionText:
        'Coral reefs represent some of the most biodiverse ecosystems on Earth, harboring nearly a quarter of all marine species despite covering less than one percent of the ocean floor. ----. When sea temperatures rise persistently, corals expel the symbiotic photosynthetic algae living inside their tissues. Deprived of their primary energy source, corals turn entirely white and, if elevated temperatures endure, suffer widespread mortality.',
    options: [
      'A) Marine biologists are exploring deep-sea hydrothermal vents for new species',
      'B) Commercial tourism generates billions of dollars for tropical island economies',
      'C) However, these fragile ecosystems are increasingly vulnerable to thermal stress caused by climate change',
      'D) Coastal communities frequently rely on fish as a staple source of dietary protein',
      'E) Artificial reefs made of recycled concrete have been deployed in temperate waters',
    ],
    correctIndex: 2, // C
    explanation:
        'DOĞRU CEVAP: C\n\n'
        'Boşluktan önceki cümle mercan resiflerinin zenginliğinden bahsederken, boşluktan sonraki cümle deniz suyu sıcaklığının artması ("sea temperatures rise") ve mercanların beyazlayıp ölmesi ("turn entirely white and suffer mortality") konusuna geçmektedir.\n'
        'Bu iki bölümü zıtlıkla bağlayıp iklim değişikliği ve termal strese dikkat çeken tek cümle C şıkkıdır.',
    difficulty: 'Orta',
    isPremiumOnly: true,
  ),
  const Question(
    id: 'q_par_2',
    category: QuestionCategory.paragraphCompletion,
    questionText:
        'In the ancient Mediterranean, olive oil was much more than a culinary staple. It served as a valuable trade commodity, an essential fuel for clay lamps, and a base for medicinal ointments. ----. Athletes coated their bodies with olive oil prior to training to protect their skin from scorching sunlight and abrasive arena dust.',
    options: [
      'A) Roman emperors imposed heavy taxes on grain imported from Egypt',
      'B) Furthermore, it played a central role in hygiene and physical culture',
      'C) Olive trees require temperate winters and hot, dry summers to produce fruit',
      'D) Modern olive oils are graded according to their acidity levels',
      'E) Pottery jars known as amphorae were used exclusively for transporting wine',
    ],
    correctIndex: 1, // B
    explanation:
        'DOĞRU CEVAP: B\n\n'
        'Boşluktan sonraki cümlede sporcuların ("Athletes") antrenmandan önce vücutlarına zeytinyağı sürdüğü ve ciltlerini koruduğu anlatılmaktadır.\n'
        'Buna zemin hazırlayan ve zeytinyağının hijyen ile beden kültüründeki ("hygiene and physical culture") rolüne değinen cümle B şıkkıdır.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),

  // ================= 10. ANLAM BÜTÜNLÜĞÜNÜ BOZAN CÜMLE (IRRELEVANT) =================
  const Question(
    id: 'q_irr_1',
    category: QuestionCategory.irrelevantSentence,
    questionText:
        '(I) Urban green spaces, such as municipal parks and rooftop gardens, play an indispensable role in mitigating the urban heat island effect. '
        '(II) By providing shade and transpiring moisture, vegetation cools surrounding city quarters considerably. '
        '(III) In addition, urban trees capture harmful airborne particulates and attenuate noise pollution. '
        '(IV) Overcrowded commuter trains often lead to heightened psychological stress among urban workers. '
        '(V) Consequently, urban planners increasingly incorporate green infrastructure into modern city designs.',
    options: [
      'A) I',
      'B) II',
      'C) III',
      'D) IV',
      'E) V',
    ],
    correctIndex: 3, // D) IV
    explanation:
        'DOĞRU CEVAP: D) IV\n\n'
        'Paragrafın Ana Fikri:\n'
        'Metnin I, II, III ve V numaralı cümleleri kentsel yeşil alanların (ağaçlar, parklar, çatı bahçeleri) şehri serinletme, hava kirliliğini temizleme ve gürültüyü azaltma gibi çevresel faydalarını anlatmaktadır.\n'
        'IV numaralı cümle ise konudan koparak kalabalık banliyö trenlerinin çalışanlarda yarattığı stresten bahsetmektedir.\n'
        'Bu nedenle akışı bozan cümle IV\'tür.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),
  const Question(
    id: 'q_irr_2',
    category: QuestionCategory.irrelevantSentence,
    questionText:
        '(I) For centuries, lighthouses were vital navigational beacons that guided mariners safely past treacherous coastal shoals and jagged reefs. '
        '(II) Keepers endured solitary, arduous lives ensuring that optical lanterns remained illuminated through tempestuous nights. '
        '(III) Commercial aviation revolutionized international mail delivery during the early twentieth century. '
        '(IV) With the advent of satellite global positioning systems, traditional lighthouses gradually lost their navigational indispensability. '
        '(V) Today, many historic lighthouse structures are preserved as cherished maritime heritage landmarks.',
    options: [
      'A) I',
      'B) II',
      'C) III',
      'D) IV',
      'E) V',
    ],
    correctIndex: 2, // C) III
    explanation:
        'DOĞRU CEVAP: C) III\n\n'
        'Paragrafın ana konusu deniz fenerlerinin (lighthouses) denizcilik tarihi içindeki gelişimi, görevlilerin yaşamı ve GPS ile beraber müzelere/tarihi anıtlara dönüşmesidir.\n'
        'III numaralı cümle deniz fenerleriyle hiçbir ilgisi olmaksızın "ticari havacılığın posta dağıtımını devrimleştirmesi"nden bahsetmektedir.',
    difficulty: 'Orta',
    isPremiumOnly: false,
  ),
];
