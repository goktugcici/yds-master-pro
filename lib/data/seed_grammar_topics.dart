import '../models/grammar_topic.dart';
import '../models/question.dart';

final List<GrammarTopic> defaultGrammarTopics = [
  const GrammarTopic(
    id: 'gram_tenses',
    title: 'Tense Uyumu & Zaman Bağlaçları',
    subtitle: 'Since, By the time, Until ve ÖSYM zaman yasaları',
    category: QuestionCategory.grammar,
    level: 'B2',
    goldenRules: [
      'Zaman bağlaçlarının (when, while, after, before, until, as soon as, by the time) bulunduğu yan cümleye ASLA will, would veya shall gelmez.',
      'Zaman Uyumu Kuralı: Ana cümle Present ise yan cümle Present/Future; ana cümle Past ise yan cümle mutlaka Past (V2, had V3, was Ving) olmalıdır.',
      'Since Kuralı: "Since + Simple Past (V2) , Present Perfect (have/has V3)" formülü YDS\'nin değişmez kalıbıdır.',
      'By the Time Kuralı: "By the time + V1 , will have V3" (geleceğe yönelik) veya "By the time + V2 , had V3" (geçmişe yönelik) çeker.',
    ],
    examTraps: [
      'ÖSYM Tuzağı: "In recent years", "over the past decade", "lately" ifadeleri geçmişe değil Present Perfect Tense\'e (have/has V3) aittir.',
      'Zaman bağlacından hemen sonra "will" seçeneğini görür görmez eleyin!',
    ],
    keyFormulas: [
      'Since + V2 (Geçmiş) ---> Have/Has V3 (Günümüze kadar)',
      'By the time + V1 ---> Will have V3 (Gelecekte bitmiş olacak)',
      'By the time + V2 ---> Had V3 (Geçmişte daha önce bitmişti)',
      'No sooner had + V3 ... THAN + V2',
      'Hardly / Scarcely had + V3 ... WHEN / BEFORE + V2',
    ],
    examples: [
      GrammarExample(
        english: 'Ever since the printing press was invented in the 15th century, access to knowledge has expanded exponentially.',
        turkish: 'Matbaa 15. yüzyılda icat edildiğinden bu yana, bilgiye erişim katlanarak genişlemiştir.',
        analysis: 'Since yan cümlesinde Simple Past (was invented), ana cümlede Present Perfect (has expanded) kullanılmıştır.',
      ),
      GrammarExample(
        english: 'By the time the intergovernmental summit concludes tomorrow, delegates will have drafted a binding accord.',
        turkish: 'Hükümetlerarası zirve yarın sona erene kadar, delegeler bağlayıcı bir anlaşma hazırlamış olacaklar.',
        analysis: 'By the time + Present (concludes) gelecekte tamamlanmış bir süreci ifade etmek için Future Perfect (will have drafted) gerektirir.',
      ),
    ],
  ),
  const GrammarTopic(
    id: 'gram_conjunctions',
    title: 'Bağlaçlar & Geçiş İfadeleri',
    subtitle: 'Zıtlık, Sebep-Sonuç, Koşul ve Paralellik Bağlaçları',
    category: QuestionCategory.grammar,
    level: 'C1',
    goldenRules: [
      'Cümle Alanlar vs İsim Alanlar: Although, Even though, Whereas arkasından tam cümle (Özne + Yüklem) alır. Despite, In spite of ise sadece isim veya isim öbeği (Noun / Ving) alır.',
      'İki Tam Cümleyi Noktalı Virgülle Bağlayanlar: However, Nonetheless, Nevertheless, On the other hand, Consequently ifadeleri geçiş zarfıdır (Transitional Words) ve iki bağımsız cümleyi noktalama ile bağlar.',
      'Whereas ve While iki farklı grup veya nesneyi zıtlık temelinde doğrudan kıyaslar ("Scandinavia invests in bikes, whereas North America relies on cars").',
      'Inasmuch as ve In that ifadeleri "çünkü / -dığı için" anlamında sebep bildirir.',
    ],
    examTraps: [
      'Despite that / In spite of that ifadeleri cümle alabilir, ancak yalın Despite arkasından asla doğrudan cümle gelemez!',
      'Although ile But aynı cümlede ASLA birlikte kullanılmaz.',
    ],
    keyFormulas: [
      'Although / Even though / Though + Cümle (S + V + O)',
      'Despite / In spite of + İsim (Noun / Ving / The fact that...)',
      'Because / Since / As / Inasmuch as + Cümle',
      'Because of / Due to / Owing to / On account of + İsim',
      'Not only ... BUT ALSO ... (Paralel yapı)',
    ],
    examples: [
      GrammarExample(
        english: 'Despite stringent monetary sanctions, the regime managed to finance several key infrastructure projects.',
        turkish: 'Sıkı mali yaptırımlara rağmen rejim, birkaç kilit altyapı projesini finanse etmeyi başardı.',
        analysis: 'Despite arkasından cümle değil bir sıfat tamlaması ("stringent monetary sanctions") gelmiştir.',
      ),
      GrammarExample(
        english: 'Whereas developed economies are curbing fossil subsidies, emerging nations struggle to decouple growth from emissions.',
        turkish: 'Gelişmiş ekonomiler fosil sübvansiyonlarını kısarken, gelişmekte olan ülkeler büyümeyi emisyonlardan ayrıştırmakta zorlanıyor.',
        analysis: 'Whereas ile iki zıt ekonomik gerçeklik birebir kıyaslanmaktadır.',
      ),
    ],
  ),
  const GrammarTopic(
    id: 'gram_modals',
    title: 'Modals & Perfect Modals',
    subtitle: 'Must have V3, Could have V3, Should have V3 ve Geçmiş Çıkarımlar',
    category: QuestionCategory.grammar,
    level: 'B2',
    goldenRules: [
      'Must have V3: Geçmişe dair kesin olumlu çıkarım ("Kesinlikle yapmış olmalı"). Kanıt güçlüdür.',
      'Can\'t / Couldn\'t have V3: Geçmişe dair kesin olumsuz çıkarım ("Yapmış olamaz").',
      'Should have V3 (veya Ought to have V3): Geçmişte yapılması gerekirdi ama yapılmadı ("Yapmalıydı ama yapmadı - Pişmanlık").',
      'Could have V3: Geçmişte yapabilirdi ama yapmadı ("Kaçırılmış fırsat").',
      'Needn\'t have V3: Yaptı ama yapmasına hiç gerek yoktu ("Boşuna yaptı").',
    ],
    examTraps: [
      'Must have V3 geçmişteki zorunluluk DEĞİLDİR! Geçmişteki zorunluluk "Had to V1" ile anlatılır. Must have V3 sadece güçlü tahmindir.',
      'Didn\'t need to V1 (gerek yoktu, yapmadı) ile Needn\'t have V3 (gerek yoktu ama yaptı) farkına çok dikkat edin!',
    ],
    keyFormulas: [
      'Must have V3 = %95 Geçmiş Güçlü Olumlu Çıkarım',
      'Can\'t have V3 = %95 Geçmiş İmkansızlık Çıkarımı',
      'Should have V3 = Yapmalıydı (Yapmadı)',
      'Could have V3 = Yapabilirdi (Tercih etmedi)',
      'Had to V1 = Geçmişte zorundaydı',
    ],
    examples: [
      GrammarExample(
        english: 'The geological strata show severe thermal fractures; volcanic activity must have occurred here millennia ago.',
        turkish: 'Jeolojik katmanlar ciddi termal kırıklar gösteriyor; bin yıllar önce burada volkanik aktivite meydana gelmiş olmalı.',
        analysis: 'Görülen fiziksel kanıta dayanarak geçmişe dair kesin çıkarım "must have occurred" ile yapılmıştır.',
      ),
      GrammarExample(
        english: 'The clinical team should have halted the drug trials when initial hepatic toxicity was detected.',
        turkish: 'İlk karaciğer toksisitesi tespit edildiğinde klinik ekip ilaç denemelerini durdurmalıydı.',
        analysis: 'Durdurması gerekirdi ama durdurmadı anlamında geçmiş pişmanlık "should have halted" ile vurgulanır.',
      ),
    ],
  ),
  const GrammarTopic(
    id: 'gram_conditionals',
    title: 'Koşul Cümleleri & Devrik Şartlar',
    subtitle: 'Type 1-2-3, Mixed Conditionals ve Devrik Şart Formülleri',
    category: QuestionCategory.grammar,
    level: 'C1',
    goldenRules: [
      'Type 1 (Gerçek / Gelecek): If + V1 , will / can / may + V1',
      'Type 2 (Hayali / Şimdiki Zaman): If + V2 , would / could / might + V1',
      'Type 3 (Geçmiş / Değiştirilemez): If + had V3 , would have / could have / might have + V3',
      'Devrik Type 1: If yerine "Should + Özne + V1"',
      'Devrik Type 2: If yerine "Were + Özne + to V1"',
      'Devrik Type 3: If yerine "Had + Özne + V3" (YDS\'de en çok çıkan devrik şart formülüdür!)',
    ],
    examTraps: [
      'Unless = If not demektir. Unless\'in bulunduğu cümlede ayrıca olumsuzluk eki (not/never) aranmaz!',
      '"Had the engineers detected the fault..." yapısı soru cümlesi değil, "If the engineers had detected..." anlamına gelen devrik şarttır!',
    ],
    keyFormulas: [
      'Devrik Type 1: Should you encounter any issues, notify us.',
      'Devrik Type 2: Were the currency to collapse, inflation would surge.',
      'Devrik Type 3: Had the vaccine been approved earlier, thousands would have been saved.',
      'Without / But for + İsim = ... olmasaydı (Type 2 veya 3 çeker)',
    ],
    examples: [
      GrammarExample(
        english: 'Had early navigators possessed accurate chronometers, maritime shipwrecks could have been largely averted.',
        turkish: 'Eğer erken dönem denizcileri hassas kronometrelere sahip olsaydı, deniz kazaları büyük ölçüde önlenebilirdi.',
        analysis: 'Had + S + V3 yapısı Type 3 devrik şart cümlesidir; sonuç kısmında "could have been averted" kullanılmıştır.',
      ),
    ],
  ),
  const GrammarTopic(
    id: 'gram_reductions',
    title: 'Kısaltmalar (Participle Reductions)',
    subtitle: 'Ving, V3, Having V3 ve Özne Ortaklığı Kuralı',
    category: QuestionCategory.grammar,
    level: 'C1',
    goldenRules: [
      'Özne Ortaklığı Kuralı: Kısaltma ile başlayan yan cümlenin öznesi, virgülden sonraki ana cümlenin öznesi ile AYNI olmak zorundadır.',
      'Aktif Eşzamanlı Kısaltma: Ving ("Realizing the hazard, the captain changed course.")',
      'Pasif Kısaltma: V3 ("Written in Latin, the manuscripts remained unread for centuries.")',
      'Öncelik Bildiren Kısaltma: Eylem ana cümleden önce tamamlanmışsa "Having + V3" (Aktif) veya "Having been + V3" (Pasif) kullanılır.',
      'Sıfat / Sıra Sayılarından Sonra Kısaltma: "The first", "the only", "the best" gibi yapılardan sonra kısaltma "to V1" veya "to have V3" ile yapılır.',
    ],
    examTraps: [
      'Virgülden sonra gelen ana cümlenin öznesine dikkat edin! Eğer kısaltılan eylemi yapan o özne değilse, şık doğrudan yanlıştır.',
    ],
    keyFormulas: [
      'Aktif Kısaltma: [ Ving ... , Subject + Verb ]',
      'Pasif Kısaltma: [ V3 ... , Subject + Verb ]',
      'Öncelikli Aktif: [ Having V3 ... , Subject + Verb ]',
      'Öncelikli Pasif: [ Having been V3 ... , Subject + Verb ]',
      'The first / only / last / superlative ---> TO V1',
    ],
    examples: [
      GrammarExample(
        english: 'Having exhausted all conventional diplomatic remedies, the coalition council resolved to impose an embargo.',
        turkish: 'Tüm geleneksel diplomatik çareleri tüketen koalisyon konseyi, bir ambargo uygulamaya karar verdi.',
        analysis: 'Çareleri tüketme eylemi önce bittiği için "Having exhausted" kullanılmıştır; eylemi yapan virgülden sonraki "the coalition council"dir.',
      ),
      GrammarExample(
        english: 'Marie Curie was the first woman to receive a Nobel Prize in two distinct scientific disciplines.',
        turkish: 'Marie Curie, iki ayrı bilim dalında Nobel Ödülü alan ilk kadındı.',
        analysis: '"The first woman" ifadesinden sonra kısaltma kural gereği "to receive" olmuştur.',
      ),
    ],
  ),
];
