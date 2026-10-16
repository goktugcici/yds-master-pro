import '../models/reading_article.dart';

final List<ReadingArticle> defaultReadingArticles = [
  const ReadingArticle(
    id: 'read_1',
    title: 'The Miraculous Plasticity of the Human Brain',
    topic: 'Tıp & Biyoloji',
    level: 'B2 - C1',
    readTimeMinutes: 4,
    contentEn:
        'For decades, conventional neuroscience maintained that the adult human brain was a static, immutable organ. It was widely believed that once brain development ceased in early adulthood, neural circuits became permanent and could not generate new pathways following significant traumatic injuries or neurological degradation.\n\n'
        'However, groundbreaking research in neurobiology over the past twenty years has completely dismantled this rigid doctrine. Scientists have conclusively demonstrated that the human brain retains a remarkable property known as "neuroplasticity"—the intrinsic capacity to reorganize its neural architecture and functional networks throughout an individual\'s entire lifespan in response to novel learning experiences, cognitive stimulation, and environmental challenges.\n\n'
        'When patients suffer ischemic strokes that impair motor functions or speech processing centers, intensive rehabilitation can prompt dormant brain areas to compensate for the damaged regions by forging alternative synaptic connections. Furthermore, engaging in mentally stimulating activities, such as mastering a foreign language or acquiring complex musical instruments, has been shown to physically increase gray matter volume in regions vital for memory consolidation and analytical reasoning. Consequently, cultivating continuous cognitive engagement is now recognized as a potent defense against age-related cognitive decline.',
    contentTr:
        'Onlarca yıl boyunca klasik sinirbilim, yetişkin insan beyninin durağan ve değişmez bir organ olduğunu savundu. Erken yetişkinlikte beyin gelişimi tamamlandıktan sonra nöral devrelerin kalıcı hale geldiği ve ağır travmatik yaralanmalar veya nörolojik yıpranmaların ardından yeni yollar üretemeyeceğine yaygın şekilde inanılıyordu.\n\n'
        'Ancak son yirmi yılda nörobiyoloji alanında yapılan çığır açıcı araştırmalar bu katı doktrini tamamen çürüttü. Bilim insanları, insan beyninin tüm yaşam süresi boyunca yeni öğrenme deneyimlerine, zihinsel uyarılara ve çevresel zorluklara yanıt olarak nöral mimarisini ve işlevsel ağlarını yeniden düzenleme konusunda doğuştan gelen bir yeteneğe, yani "nöroplastisite"ye sahip olduğunu kesin olarak kanıtladı.\n\n'
        'Hastalar motor fonksiyonları veya konuşma merkezlerini bozan felçler geçirdiğinde, yoğun rehabilitasyon süreci uykudaki beyin bölgelerini alternatif sinaptik bağlantılar kurarak hasarlı bölgeleri telafi etmeye teşvik edebilmektedir. Dahası, yabancı bir dilde ustalaşmak veya karmaşık müzik aletleri çalmak gibi zihni uyarıcı etkinliklerle meşgul olmanın, hafıza ve analitik düşünme için hayati olan bölgelerde gri madde hacmini fiziksel olarak artırdığı gösterilmiştir. Sonuç olarak, zihni sürekli aktif tutmanın yaşa bağlı zihinsel gerilemeye karşı güçlü bir kalkan olduğu artık kabul edilmektedir.',
    vocabulary: [
      ReadingVocab(
        english: 'immutable',
        turkish: 'değişmez, sabit',
        definition: 'Not capable of or susceptible to change.',
      ),
      ReadingVocab(
        english: 'dismantle',
        turkish: 'çürütmek, parçalara ayırmak',
        definition: 'To take apart or break down established concepts or structures.',
      ),
      ReadingVocab(
        english: 'intrinsic',
        turkish: 'doğuştan gelen, özünde olan',
        definition: 'Belonging naturally; essential and inherent.',
      ),
      ReadingVocab(
        english: 'compensate for',
        turkish: 'telafi etmek, yerini doldurmak',
        definition: 'To make up for a lack, loss, or deficiency.',
      ),
      ReadingVocab(
        english: 'cognitive decline',
        turkish: 'bilişsel / zihinsel gerileme',
        definition: 'Deterioration in mental processes such as memory and attention.',
      ),
    ],
    questions: [
      ReadingQuestion(
        questionText:
            'According to the passage, earlier neurological assumptions were flawed because ----.',
        options: [
          'A) they presumed the mature human brain lacked the capability to structurally adapt or reorganize',
          'B) they failed to recognize that children could recover from severe head injuries',
          'C) they argued that memory storage occurs exclusively in the motor cortex',
          'D) they claimed that stroke victims could never receive physical rehabilitation',
          'E) they overestimated the impact of musical training on brain architecture',
        ],
        correctIndex: 0,
        explanation:
            'Doğru Cevap: A. Metnin ilk paragrafında eski sinirbilimin beynin değişmez ("immutable") olduğunu ve yeni yolaklar üretemeyeceğini sandığı, ancak bunun yanlış olduğu vurgulanmaktadır.',
      ),
      ReadingQuestion(
        questionText:
            'It can be inferred from the text that learning a foreign language or musical skill ----.',
        options: [
          'A) is effective only when introduced during early infancy',
          'B) physically alters neural structures and reinforces cognitive durability against aging',
          'C) exhausts the brain\'s limited capacity to form new synaptic connections',
          'D) prevents all physical damage caused by ischemic strokes',
          'E) is completely unrelated to gray matter density',
        ],
        correctIndex: 1,
        explanation:
            'Doğru Cevap: B. Son paragrafta yabancı dil veya müzik öğrenmenin gri madde hacmini artırdığı ("physically increase gray matter volume") ve yaşa bağlı zihinsel gerilemeye karşı koruma sağladığı açıkça ifade edilmektedir.',
      ),
    ],
    isProOnly: false,
  ),
  const ReadingArticle(
    id: 'read_2',
    title: 'The Geopolitical Economics of Renewable Energy Transitions',
    topic: 'Ekonomi & Çevre',
    level: 'C1',
    readTimeMinutes: 5,
    contentEn:
        'The transition from hydrocarbon dependence toward low-carbon energy systems is widely celebrated as an ecological imperative to avert catastrophic climatic disruption. Yet beneath the environmental rhetoric lies a seismic restructuring of international trade balances and global geopolitical power dynamics.\n\n'
        'For over a century, sovereign influence was heavily correlated with access to fossil fuel reserves. Petrostates leveraged oil and gas exports to command formidable geopolitical clout, shaping foreign policies and dictating terms in diplomatic negotiations. The rapid expansion of solar photovoltaic panels, wind turbines, and grid-scale lithium storage batteries is fundamentally upending this hierarchy. Energy generation is increasingly shifting from extractive geographic monopolies to technological manufacturing capacities.\n\n'
        'However, this energy transition is not without new vulnerabilities. While renewable resources like sunlight and wind are boundless and geographically decentralized, the critical mineral supply chains necessary to capture, store, and convert this power—including cobalt, nickel, rare earth elements, and lithium—are concentrated in a handful of developing and emerging economies. Consequently, strategic competition has pivoted from securing maritime petroleum choke points to monopolizing extraction and refining operations of energy-transition minerals.',
    contentTr:
        'Hidrokarbon bağımlılığından düşük karbonlu enerji sistemlerine geçiş, felaket boyutundaki iklimsel yıkımı önlemek adına ekolojik bir zorunluluk olarak geniş kitlelerce övgüyle karşılanmaktadır. Ancak çevresel söylemin altında, uluslararası ticaret dengelerinin ve küresel jeopolitik güç dinamiklerinin sarsıcı bir yeniden yapılanması yatmaktadır.\n\n'
        'Yüzyıldan uzun bir süre boyunca devletlerin egemenlik gücü, fosil yakıt rezervlerine erişimle yakından ilişkiliydi. Petrol devletleri, dış politikaları şekillendirmek ve diplomatik müzakerelerde şartları dikte etmek için petrol ve doğalgaz ihracatını büyük bir jeopolitik koz olarak kullandı. Güneş panellerinin, rüzgar türbinlerinin ve şebeke ölçekli lityum depolama pillerinin hızlı yayılışı bu hiyerarşiyi kökten sarsmaktadır. Enerji üretimi, coğrafi hammadde tekellerinden teknolojik üretim kapasitelerine doğru kaymaktadır.\n\n'
        'Bununla birlikte, bu enerji dönüşümü yeni kırılganlıklardan muaf değildir. Güneş ışığı ve rüzgar gibi yenilenebilir kaynaklar sınırsız ve coğrafi olarak merkeziyetsiz olsa da, bu enerjiyi yakalamak, depolamak ve dönüştürmek için zorunlu olan kritik mineral tedarik zincirleri (kobalt, nikel, nadir toprak elementleri ve lityum) bir avuç gelişmekte olan ve yükselen ekonomide yoğunlaşmıştır. Dolayısıyla stratejik rekabet, deniz petrol geçiş noktalarını güvenceye almaktan, enerji dönüşümü minerallerinin çıkarılması ve rafine edilmesini tekelleştirmeye doğru kaymıştır.',
    vocabulary: [
      ReadingVocab(
        english: 'imperative',
        turkish: 'zorunluluk, olmazsa olmaz',
        definition: 'An essential or urgent duty or requirement.',
      ),
      ReadingVocab(
        english: 'leverage',
        turkish: 'koz olarak kullanmak, yararlanmak',
        definition: 'To exploit or use something to maximum advantage.',
      ),
      ReadingVocab(
        english: 'upend',
        turkish: 'altüst etmek, tepe taklak etmek',
        definition: 'To set on end, overturn, or thoroughly revolutionize.',
      ),
      ReadingVocab(
        english: 'boundless',
        turkish: 'sınırsız, uçsuz bucaksız',
        definition: 'Unlimited, vast, or having no boundaries.',
      ),
      ReadingVocab(
        english: 'choke point',
        turkish: 'stratejik dar geçit (boğaz vb.)',
        definition: 'A strategic narrow route providing passage through an area.',
      ),
    ],
    questions: [
      ReadingQuestion(
        questionText:
            'The primary purpose of the author in this passage is to ----.',
        options: [
          'A) illustrate how clean energy deployment transforms geopolitical power relations and creates new supply vulnerabilities',
          'B) argue that fossil fuels remain superior to solar and wind infrastructure',
          'C) encourage nations to discontinue mining lithium and cobalt due to ecological toxicity',
          'D) prove that petrostates will permanently maintain their dominance over international markets',
          'E) calculate the exact financial cost of transitioning to net-zero carbon emissions',
        ],
        correctIndex: 0,
        explanation:
            'Doğru Cevap: A. Metin, yenilenebilir enerjiye geçişin sadece çevresel değil, jeopolitik güç dengelerini nasıl değiştirdiğini ve yeni mineral bağımlılıkları yarattığını açıklamaktadır.',
      ),
      ReadingQuestion(
        questionText:
            'It is emphasized in the passage that critical transition minerals such as lithium and cobalt ----.',
        options: [
          'A) are found uniformly and abundantly in every continent across the globe',
          'B) have become the focal point of new international economic and geopolitical competition',
          'C) will become entirely obsolete within the next several decades',
          'D) can be easily substituted by synthetic polymers in battery manufacturing',
          'E) are exclusively refined in petrostate economies',
        ],
        correctIndex: 1,
        explanation:
            'Doğru Cevap: B. Son paragrafta kritik minerallerin az sayıda ülkede yoğunlaştığı ve stratejik rekabetin bu mineralleri tekelleştirmeye yöneldiği belirtilmektedir.',
      ),
    ],
    isProOnly: true,
  ),
  const ReadingArticle(
    id: 'read_3',
    title: 'Urban Architecture and Water Management in Ancient Mesopotamia',
    topic: 'Tarih & Arkeoloji',
    level: 'B2',
    readTimeMinutes: 4,
    contentEn:
        'The fertile plains situated between the Tigris and Euphrates rivers served as the crucible of human civilization. In this arid expanse, the Sumerians and subsequent Mesopotamian societies erected colossal mud-brick metropolises, supported by groundbreaking agricultural innovations.\n\n'
        'Because seasonal precipitation was erratic and droughts were frequent, survival demanded unprecedented hydrological mastery. Mesopotamian engineers constructed intricate networks of irrigation canals, dikes, aqueducts, and retention reservoirs to channel catastrophic floodwaters away from city walls while simultaneously storing moisture for dry-season crop cultivation. These complex public works were not merely technical achievements; they necessitated centralized administrative bureaucracies, giving birth to the earliest forms of written accounting and civic governance in human history.\n\n'
        'Nevertheless, the very irrigation systems that fostered Mesopotamian prosperity eventually sowed the seeds of its agricultural decline. Continuous canal irrigation in an arid climate with poor subterranean drainage caused mineral salts to accumulate in the topsoil. Over generations, soil salinization decimated barley and wheat yields, ultimately precipitating the political fragmentation and eventual collapse of these ancient urban centers.',
    contentTr:
        'Dicle ve Fırat nehirleri arasında uzanan verimli ovalar, insan uygarlığının beşiği olarak hizmet etti. Bu kurak coğrafyada Sümerler ve ardılları olan Mezopotamya toplumları, çığır açan tarımsal yeniliklerle desteklenen devasa kerpiç metropoller inşa ettiler.\n\n'
        'Mevsimsel yağışlar düzensiz ve kuraklıklar sık olduğu için, hayatta kalmak eşi benzeri görülmemiş bir hidrolojik uzmanlık gerektiriyordu. Mezopotamyalı mühendisler, yıkıcı sel sularını şehir surlarından uzaklaştırırken aynı zamanda kurak mevsim tarımı için nem depolamak amacıyla karmaşık sulama kanalları, bentler, su kemerleri ve rezervuarlar inşa ettiler. Bu karmaşık bayındırlık işleri yalnızca teknik başarılar değildi; merkezi idari bürokrasileri zorunlu kılarak insanlık tarihindeki en erken yazılı muhasebe ve sivil yönetim biçimlerini doğurdu.\n\n'
        'Ne var ki, Mezopotamya\'nın refahını sağlayan bu sulama sistemleri, nihayetinde tarımsal çöküşünün tohumlarını da ekti. Yetersiz yeraltı drenajına sahip kurak bir iklimde sürekli kanal sulaması yapılması, mineral tuzların üst toprakta birikmesine neden oldu. Nesiller boyunca toprak tuzlanması arpa ve buğday verimini yerle bir etti ve nihayetinde bu kadim şehir merkezlerinin siyasi parçalanmasına ve çöküşüne zemin hazırladı.',
    vocabulary: [
      ReadingVocab(
        english: 'crucible',
        turkish: 'beşik, pota, zorlu sınav yeri',
        definition: 'A situation or place where concentrated forces interact to produce something new.',
      ),
      ReadingVocab(
        english: 'erratic',
        turkish: 'düzensiz, tutarsız, değişken',
        definition: 'Not even or regular in pattern or movement; unpredictable.',
      ),
      ReadingVocab(
        english: 'hydrological',
        turkish: 'su bilimiyle ilgili',
        definition: 'Relating to the properties, distribution, and circulation of water.',
      ),
      ReadingVocab(
        english: 'sow the seeds of',
        turkish: 'tohumlarını ekmek, yol açmak',
        definition: 'To do something that will eventually cause a particular result.',
      ),
      ReadingVocab(
        english: 'precipitate',
        turkish: 'hızlandırmak, aniden tetiklemek',
        definition: 'To cause an event or situation to happen suddenly or prematurely.',
      ),
    ],
    questions: [
      ReadingQuestion(
        questionText:
            'It can be understood from the passage that large-scale irrigation projects in Mesopotamia ----.',
        options: [
          'A) indirectly spurred the emergence of structured administration and written records',
          'B) eliminated all risk of drought for thousands of consecutive years',
          'C) were constructed without requiring any engineering knowledge',
          'D) relied entirely on rainfall rather than river waters',
          'E) prevented the growth of urban populations',
        ],
        correctIndex: 0,
        explanation:
            'Doğru Cevap: A. İkinci paragrafta sulama çalışmalarının merkezi bürokrasiyi gerektirdiği ve en erken yazılı muhasebe ve yönetim biçimlerini doğurduğu belirtilmektedir.',
      ),
      ReadingQuestion(
        questionText:
            'According to the passage, the downfall of Mesopotamian agriculture was primarily driven by ----.',
        options: [
          'A) excessive military expenditure on foreign conquests',
          'B) the gradual accumulation of salt in the soil resulting from long-term canal irrigation',
          'C) an unexpected permanent drought that dried up both rivers simultaneously',
          'D) the complete destruction of canal reservoirs by neighboring empires',
          'E) a sudden transition to nomadic hunting lifestyles',
        ],
        correctIndex: 1,
        explanation:
            'Doğru Cevap: B. Son paragrafta kanal sulamasının toprakta mineral tuz birikimine ("soil salinization") ve ürün veriminin düşmesine yol açtığı anlatılmaktadır.',
      ),
    ],
    isProOnly: false,
  ),
];
