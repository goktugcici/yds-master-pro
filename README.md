# 🎓 YDS Master PRO - Modern YDS Hazırlık & Abonelik Tabanlı Mobil Uygulama

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-blueviolet)
![Tests](https://img.shields.io/badge/Tests-32%2F32%20Passing-brightgreen)
![License](https://img.shields.io/badge/License-MIT-green)

**YDS Master PRO**, ÖSYM'nin Yabancı Dil Bilgisi Seviye Tespit Sınavı (YDS) ve YÖKDİL adayları için tasarlanmış, **Freemium + Abonelik (In-App Purchase)** gelir modeline sahip, modern ve yüksek performanslı bir Flutter mobil uygulamasıdır.

---

## 🚀 Öne Çıkan Özellikler

### 1. 🧠 Akıllı Kelime Ezberleme & SRS (Spaced Repetition)
- **1,500+ YDS Akademik Kelimesi**: Fiiller, İsimler, Sıfatlar, Zarflar, Phrasal Verbs ve Prepositional Phrases.
- **Leitner 5 Seviyeli Hafıza Algoritması**: Bilinen ve bilinmeyen kelimeleri periyodik aralıklarla tekrar ettiren akıllı algoritma.
- **3D Çevirmeli Flashcard**: Türkçe anlam, İngilizce tanım, eş anlamlılar (synonyms), zıt anlamlılar (antonyms) ve örnek sınav cümleleri.
- **Hızlı Kelime Quizi**: 4 şıklı hızlı pratik testleri.
- **Eş Anlamlı Eşleştirme Mini Oyunu**: İnteraktif ve eğlenceli eşleştirme egzersizi.

### 2. 📚 11 Soru Kategorisi & 1,200+ Açıklamalı Soru
ÖSYM'nin standart YDS soru dağılımına birebir uygun kategori mimarisi:
1. **Kelime Bilgisi (Vocabulary)**
2. **Gramer & Dilbilgisi (Grammar)**
3. **Cümle Tamamlama (Sentence Completion)**
4. **İngilizce - Türkçe Çeviri**
5. **Türkçe - İngilizce Çeviri**
6. **Paragraf & Okuma Parçaları (Reading Comprehension)**
7. **Yakın Anlamlı Cümle (Restatement)**
8. **Karşılıklı Konuşma / Diyalog (Dialogue Completion)**
9. **Paragraf Tamamlama (Paragraph Completion)**
10. **Anlam Bütünlüğünü Bozan Cümle (Irrelevant Sentence)**
11. **Duruma Uygun Düşen İfade (Situational)**
- *Her soruda doğru cevabın gerekçesini ve çeldiricilerin neden elendiğini anlatan pedagojik Türkçe çözüm metinleri.*

### 3. 📖 YDS Reading Atölyesi (Metin & Çeviri Analizi)
- Tıp, Ekonomi, Arkeoloji ve Sosyal Bilimler alanlarında akademik okuma parçaları.
- Türkçe çeviri gizleme/gösterme anahtarı (Bilingual Toggle).
- Metin içi kritik kelime vurguları ve paragraf kavrama soruları.

### 4. 📝 Akıllı Hata Defteri & Telafi Testi
- Soru çözerken yapılan her yanlış soru otomatik olarak "Hata Defteri"ne kaydedilir.
- **Hatalarımdan Telafi Testi**: Kullanıcının yalnızca yanlış yaptığı sorulardan oluşan kişiselleştirilmiş zayıf konu testleri.
- Doğru çözüldüğünde hata listesinden otomatik çıkarılma mekanizması.

### 5. 💡 YDS Taktik & Strateji Kartları
- **Edat & Prepositions**: Sınavda en çok çıkan 40+ edat kalıbı ve çeldiriciler (`insist on`, `lead to`, `comply with` vs.).
- **Tense Uyumu Altın Kuralları**: Since formülü, By the time kuralları, zaman bağlaçlarında will/would yasağı.
- **Devrik Cümle Formülleri (Inversion)**: Not only, Hardly...when, No sooner...than, Under no circumstances.
- **Bağlaç Grupları**: Zıtlık, Sebep-Sonuç, Koşul ve Ekleme bağlaçları.
- **ÖSYM Çeldirici Sırları**: Extreme kelimeler tuzağı, çeviride özne-yüklem taktiği.

### 6. ⏱️ Gerçek Sınav Simülatörü & Puanlama
- **Tam Deneme**: 80 Soru • 180 Dakika (Gerçek ÖSYM süresi).
- **Mini Deneme**: 20 Soru • 45 Dakika.
- 100 puan üzerinden resmi YDS puanı ve harf notu analizi (A, B, C, D, E).

### 7. 🎯 Hedef Puan & Sınav Geri Sayımı
- Canlı sınav geri sayım sayacı ("2026 YDS/2 Sınavına X Gün Kaldı").
- Hedef puan belirleme modalı (55, 70, 80, 90+) ve çalışma temposu optimizasyonu.

### 8. 💎 Aylık & Yıllık Abonelik Sistemi (Monetization & Paywall)
- **Freemium Kısıtlama Mekanizması**: Ücretsiz kullanıcılar temel soru tiplerini çözebilir; PRO kullanıcılar sınırsız erişim kazanır.
- **Dönüşüm Odaklı Paywall**: 7 gün ücretsiz deneme, karşılaştırma kartları, SSS akordeonu.
- **İndirim Kuponu Sistemi**: `YDS2026` (%25 İndirim), `HOCAM20` (%20 İndirim), `DERECE50` (%50 İndirim) gibi kupon kodlarıyla anında dinamik fiyatlandırma.
- **IAP / Store Uyumluluğu**: RevenueCat ve Google Play Billing / StoreKit entegrasyonuna hazır mimari.

---

## 🏗️ Mimari & Klasör Yapısı

```
yds_pro/
├── lib/
│   ├── main.dart                          # Başlangıç noktası & MultiProvider
│   ├── core/
│   │   ├── constants/app_colors.dart      # Renk paleti & stil sabitleri
│   │   └── theme/app_theme.dart           # Light & Dark Material 3 temaları
│   ├── models/
│   │   ├── word.dart                      # Kelime & SRS veri modeli
│   │   ├── question.dart                  # 11 YDS soru tipi modeli
│   │   ├── exam.dart                      # Deneme sınavı & sonuç modeli
│   │   ├── reading_article.dart           # Reading metin modeli
│   │   └── subscription_plan.dart         # Abonelik paketleri & kupon modeli
│   ├── providers/                         # Riverpod State Notifier'ları
│   │   ├── question_provider.dart         # Soru çözümü, hata defteri & telafi
│   │   ├── vocabulary_provider.dart       # SRS kelime ezberleme motoru
│   │   ├── exam_provider.dart             # Deneme sınavı & sayaç yönetimi
│   │   ├── stats_provider.dart            # İstatistikler, hedef puan & tarih
│   │   ├── subscription_provider.dart     # Paywall, kupon & IAP mock
│   │   └── theme_provider.dart            # Dark/Light tema durumu
│   ├── data/
│   │   └── local_storage.dart             # SharedPreferences kalıcılık katmanı
│   └── views/
│       ├── home/                          # Dashboard, streak & geri sayım
│       ├── vocabulary/                    # Flashcard, Quiz & Eşleştirme
│       ├── practice/                      # Soru bankası & soru çözümü
│       ├── exam/                          # Gerçek YDS denemesi & sonuç
│       ├── reading/                       # Akademik Reading Atölyesi
│       ├── mistakes/                      # Akıllı Hata Defteri & Telafi Testi
│       ├── strategies/                    # YDS Taktik & Strateji Kartları
│       ├── paywall/                       # PRO Abonelik & Kupon Ekranı
│       └── profile/                       # Kullanıcı ayarları & tema
├── assets/data/                           # 1500+ kelime & 1200+ soru JSON havuzu
└── test/                                  # 32/32 geçen kapsamlı test süiti
```

---

## 🛠️ Kurulum & Çalıştırma

### Gereksinimler
- Flutter SDK (3.24+ / 3.41+)
- Dart SDK (3.5+ / 3.11+)

### 1. Bağımlılıkları Yükleme
```bash
flutter pub get
```

### 2. Testleri Çalıştırma
```bash
flutter test
```
*Tüm 32 birim ve widget testi eksiksiz başarıyla geçer.*

### 3. Uygulamayı Başlatma
```bash
# Web üzerinde çalıştırmak için:
flutter run -d chrome

# Android / iOS cihazda çalıştırmak için:
flutter run

# Web release derlemesi almak için:
flutter build web --release
```

---

## 🧪 Test Kapsamı
Proje kapsamlı bir test mimarisine sahiptir (`test/comprehensive_test.dart`):
1. **LocalStorage & Persistence Tests**: Öğrenilen/favori kelimeler, seriler, hedef puan ve sınav tarihi.
2. **Vocabulary & SRS Tests**: Leitner seviye artışı, unutulan kelime tekrarı, arama ve filtreleme.
3. **Question Bank Tests**: Kategori seçimi, doğru/yanlış cevap kontrolü ve yer işaretleri.
4. **Subscription & Paywall Logic**: Ücretsiz/PRO yetkilendirmesi, kupon kodu indirimi hesaplama ve geri yükleme.
5. **Exam Engine Tests**: 180 dk sayaç, 100 üzerinden YDS puanlama ve harf notu hesaplama.
6. **UI Widget Tests**: Navigation, Flashcard/Liste sekme geçişi, Karanlık mod değişimi.
7. **Mistake Notebook & Strategy Tests**: Hata kaydı, telafi testi başlatma, strateji kartları filtreleme.

---

## 📄 Lisans
Bu proje MIT lisansı ile lisanslanmıştır.
