enum SubscriptionTier {
  free,
  proMonthly,
  proYearly,
}

class SubscriptionPlan {
  final String id;
  final SubscriptionTier tier;
  final String title;
  final String priceText;
  final String periodText;
  final String? discountBadge;
  final int trialDays;
  final List<String> features;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.tier,
    required this.title,
    required this.priceText,
    required this.periodText,
    this.discountBadge,
    this.trialDays = 0,
    required this.features,
    this.isPopular = false,
  });

  double get price {
    if (tier == SubscriptionTier.proMonthly) return 149.99;
    if (tier == SubscriptionTier.proYearly) return 899.99;
    return 0.0;
  }

  static List<SubscriptionPlan> defaultPlans() {
    return [
      const SubscriptionPlan(
        id: 'yds_pro_monthly',
        tier: SubscriptionTier.proMonthly,
        title: 'PRO Aylık Paket',
        priceText: '149,99 ₺',
        periodText: 'aylık',
        trialDays: 7,
        isPopular: false,
        features: [
          'Tüm 11 soru kategorisinde sınırsız soru bankası',
          '80 soruluk tam kapsamlı YDS deneme sınavları',
          '1500+ YDS kelimesi ve akıllı SRS tekrar sistemi',
          'Her soruda detaylı Türkçe çözüm analizleri',
          'Kişiye özel zayıf nokta & hata testi oluşturma',
          'Reklamsız ve tam odaklı çalışma deneyimi',
        ],
      ),
      const SubscriptionPlan(
        id: 'yds_pro_yearly',
        tier: SubscriptionTier.proYearly,
        title: 'PRO Yıllık Avantaj',
        priceText: '899,99 ₺',
        periodText: 'yıllık (ayda ~75 ₺)',
        discountBadge: '%50 İNDİRİM',
        trialDays: 7,
        isPopular: true,
        features: [
          'Aylık paketin TÜM özellikleri dahil',
          '12 ay boyunca kesintisiz erişim',
          'Ayda sadece 75 ₺ (En ekonomik paket)',
          'Yeni eklenen tüm soru & deneme güncellemeleri',
          'Çevrimdışı (Offline) çalışma modu',
          'Öncelikli destek & YDS strateji rehberleri',
        ],
      ),
    ];
  }
}

class UserSubscription {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isAutoRenewing;
  final bool isTrialActive;

  const UserSubscription({
    this.tier = SubscriptionTier.free,
    this.expiresAt,
    this.isAutoRenewing = false,
    this.isTrialActive = false,
  });

  bool get isPro =>
      tier == SubscriptionTier.proMonthly || tier == SubscriptionTier.proYearly;

  String get tierName {
    switch (tier) {
      case SubscriptionTier.free:
        return 'Ücretsiz Plan';
      case SubscriptionTier.proMonthly:
        return 'YDS PRO (Aylık)';
      case SubscriptionTier.proYearly:
        return 'YDS PRO (Yıllık)';
    }
  }

  UserSubscription copyWith({
    SubscriptionTier? tier,
    DateTime? expiresAt,
    bool? isAutoRenewing,
    bool? isTrialActive,
  }) {
    return UserSubscription(
      tier: tier ?? this.tier,
      expiresAt: expiresAt ?? this.expiresAt,
      isAutoRenewing: isAutoRenewing ?? this.isAutoRenewing,
      isTrialActive: isTrialActive ?? this.isTrialActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'expiresAt': expiresAt?.toIso8601String(),
      'isAutoRenewing': isAutoRenewing,
      'isTrialActive': isTrialActive,
    };
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      tier: SubscriptionTier.values.firstWhere(
        (t) => t.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
      isAutoRenewing: json['isAutoRenewing'] as bool? ?? false,
      isTrialActive: json['isTrialActive'] as bool? ?? false,
    );
  }
}
