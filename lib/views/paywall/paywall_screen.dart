import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/subscription_plan.dart';
import '../../providers/subscription_provider.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const PaywallScreen(),
      ),
    );
  }

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedPlanId = 'yds_pro_yearly';
  bool _isLoading = false;
  final TextEditingController _couponController = TextEditingController();
  int _discountPercent = 0;
  String? _appliedCouponCode;
  String? _couponError;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'YDS2026') {
      setState(() {
        _discountPercent = 25;
        _appliedCouponCode = code;
        _couponError = null;
      });
    } else if (code == 'HOCAM20') {
      setState(() {
        _discountPercent = 20;
        _appliedCouponCode = code;
        _couponError = null;
      });
    } else if (code == 'DERECE50') {
      setState(() {
        _discountPercent = 50;
        _appliedCouponCode = code;
        _couponError = null;
      });
    } else if (code == 'VIP100') {
      setState(() {
        _discountPercent = 100;
        _appliedCouponCode = code;
        _couponError = null;
      });
    } else {
      setState(() {
        _couponError = 'Geçersiz kupon. (Örn: YDS2026, HOCAM20, DERECE50)';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(subscriptionPlansProvider);
    final userSub = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedPlan = plans.firstWhere(
      (p) => p.id == _selectedPlanId,
      orElse: () => plans.first,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _handleRestore,
            child: const Text(
              'Geri Yükle',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.premiumGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.premiumGold.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.workspace_premium, color: AppColors.premiumGold, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'YDS PRO İLE HEDEFİNE ULAŞ',
                      style: TextStyle(
                        color: AppColors.premiumGoldDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fade().scale(),

            const SizedBox(height: 16),

            // Main Title & Subtitle
            Text(
              'YDS Sınavını İlk Girişte\nKazanmaya Hazır Mısın?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: isDark ? Colors.white : AppColors.textLightPrimary,
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 10),

            Text(
              'Sınırsız soru bankası, 80 soruluk gerçek denemeler, akıllı kelime ezberleme ve detaylı çözümler seni bekliyor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // Feature Highlights List
            _buildFeatureTile(
              icon: Icons.all_inclusive,
              title: 'Sınırsız Soru Bankası',
              subtitle: '11 farklı YDS kategorisinde yüzlerce açıklamalı soru',
            ),
            _buildFeatureTile(
              icon: Icons.timer,
              title: '80 Soruluk Gerçek YDS Denemeleri',
              subtitle: 'ÖSYM süre standardı ve harf notu analizi (A, B, C)',
            ),
            _buildFeatureTile(
              icon: Icons.psychology,
              title: 'SRS Akıllı Kelime Ezberleme',
              subtitle: '1500+ akademik kelime, eş anlamlılar ve örnek cümleler',
            ),
            _buildFeatureTile(
              icon: Icons.lightbulb,
              title: 'Detaylı Türkçe Çözüm Analizleri',
              subtitle: 'Çeldiricilerin neden elendiğini adım adım öğren',
            ),
            _buildFeatureTile(
              icon: Icons.cloud_off,
              title: 'Reklamsız & Çevrimdışı Çalışma',
              subtitle: 'İnternet bağlantısı olmadan her yerde kesintisiz pratik',
            ),

            const SizedBox(height: 28),

            // Plan Selection Cards
            Text(
              'Abonelik Planını Seç',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ...plans.map((plan) {
              final isSelected = plan.id == _selectedPlanId;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPlanId = plan.id;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.primary.withOpacity(0.3) : const Color(0xFFEFF6FF))
                        : (isDark ? AppColors.cardDark : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryLight : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Radio check icon
                      Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.primaryLight : Colors.grey,
                      ),
                      const SizedBox(width: 14),

                      // Plan details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  plan.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.textLightPrimary,
                                  ),
                                ),
                                if (plan.discountBadge != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      plan.discountBadge!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${plan.trialDays} gün ücretsiz deneme dahil',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (_discountPercent > 0) ...[
                            Text(
                              plan.priceText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${(plan.price * (100 - _discountPercent) / 100).toStringAsFixed(2)} ₺',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                            ),
                          ] else ...[
                            Text(
                              plan.priceText,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textLightPrimary,
                              ),
                            ),
                          ],
                          Text(
                            plan.periodText,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Coupon Code Card
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _appliedCouponCode != null
                      ? AppColors.success
                      : (_couponError != null
                          ? AppColors.error
                          : (isDark ? AppColors.borderDark : AppColors.borderLight)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.confirmation_num_outlined, size: 18, color: AppColors.primaryLight),
                      const SizedBox(width: 8),
                      const Text(
                        'İndirim / Referans Kuponu',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      if (_appliedCouponCode != null) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '%$_discountPercent İNDİRİM',
                            style: const TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Kupon kodu girin (örn: YDS2026)',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _applyCoupon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Uygula'),
                      ),
                    ],
                  ),
                  if (_couponError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _couponError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 11),
                    ),
                  ],
                  if (_appliedCouponCode != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '🎉 $_appliedCouponCode kodu uygulandı! %$_discountPercent indirim tanımlandı.',
                      style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),

            // Active Subscription Status notice if already subscribed
            if (userSub.isPro) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Şu anda ${userSub.tierName} üyesisiniz! Tüm özellikler aktif.',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Big Subscribe CTA Button
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _handleSubscribe(selectedPlan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            _discountPercent > 0
                                ? '%$_discountPercent İndirimle Başla (${(selectedPlan.price * (100 - _discountPercent) / 100).toStringAsFixed(2)} ₺)'
                                : (selectedPlan.trialDays > 0
                                    ? '${selectedPlan.trialDays} Gün Ücretsiz Başla'
                                    : 'Hemen Abone Ol'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 14),

            // Disclaimer & Terms
            Text(
              'Deneme süresi bittikten sonra seçilen paket fiyatı Google Play veya App Store hesabınızdan otomatik yenilenir. İstediğiniz zaman mağaza ayarlarından tek tıkla iptal edebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // FAQ Accordion
            _buildFaqItem(
              question: 'Aboneliğimi istediğim zaman iptal edebilir miyim?',
              answer:
                  'Evet. Google Play Store veya Apple App Store abonelikler menüsünden tek tıkla ve hiçbir ek ücret ödemeden dilediğiniz an iptal edebilirsiniz.',
              isDark: isDark,
            ),
            _buildFaqItem(
              question: '7 günlük deneme süresinde benden ücret alınır mı?',
              answer:
                  'Hayır. 7 gün boyunca tüm PRO özelliklerini tamamen ücretsiz kullanabilirsiniz. Deneme bitmeden iptal ederseniz hiçbir kesinti yapılmaz.',
              isDark: isDark,
            ),
            _buildFaqItem(
              question: 'İçerikler düzenli olarak güncelleniyor mu?',
              answer:
                  'Evet! Her YDS sınav dönemi öncesinde güncel ÖSYM soru formatlarına uygun yeni sorular ve akademik kelimeler havuza eklenir.',
              isDark: isDark,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textLightPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textLightPrimary,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe(SubscriptionPlan plan) async {
    setState(() => _isLoading = true);
    try {
      final success =
          await ref.read(subscriptionProvider.notifier).purchaseSubscription(plan);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.success,
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tebrikler! ${plan.title} başarıyla aktif edildi. Sınav yolculuğunda başarılar!',
                  ),
                ),
              ],
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    try {
      final restored =
          await ref.read(subscriptionProvider.notifier).restorePurchases();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: restored ? AppColors.success : AppColors.info,
            content: Text(
              restored
                  ? 'Aboneliğiniz başarıyla geri yüklendi!'
                  : 'Aktif bir abonelik bulunamadı.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
