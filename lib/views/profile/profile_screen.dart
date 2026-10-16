import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/theme_provider.dart';
import '../paywall/paywall_screen.dart';
import '../stats/detailed_stats_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Ayarlar'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // User Avatar & Title Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 36, color: AppColors.primaryLight),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'YDS Adayı',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: sub.isPro
                              ? AppColors.premiumGold.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          sub.isPro ? '👑 ${sub.tierName}' : 'Ücretsiz Kullanıcı',
                          style: TextStyle(
                            color: sub.isPro ? AppColors.premiumGoldDark : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Subscription Management Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: sub.isPro
                  ? const LinearGradient(
                      colors: [Color(0xFF065F46), Color(0xFF047857)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sub.isPro ? 'PRO Üyeliğiniz Aktif' : 'PRO Paketine Geçin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.workspace_premium, color: AppColors.premiumGold),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  sub.isPro
                      ? 'Tüm 11 soru türü ve 80 soruluk denemeler sınırsız açık.'
                      : 'Aylık sadece 149,99 ₺ ile tüm YDS havuzuna sınırsız erişin.',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => PaywallScreen.show(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    sub.isPro ? 'Abonelik Detayları' : '7 Gün Ücretsiz Başla',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Detailed Performance & Analytics Tile
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.insights, color: AppColors.primaryLight),
              ),
              title: const Text('Performans & Zayıf Halka Raporu', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Tahmini YDS neti, harf notu ve kategori grafiği', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DetailedStatsScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            'Uygulama Ayarları',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          // Dark Mode Switch Tile
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primaryLight,
              ),
              title: const Text('Karanlık Mod (Dark Theme)'),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Restore purchases tile
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.restore, color: AppColors.info),
              title: const Text('Aboneliği Geri Yükle'),
              subtitle: const Text('Mevcut mağaza aboneliğinizi aktifleştirin', style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final restored = await ref.read(subscriptionProvider.notifier).restorePurchases();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: restored ? AppColors.success : Colors.grey,
                      content: Text(
                        restored ? 'Abonelik geri yüklendi!' : 'Kayıtlı aktif abonelik bulunamadı.',
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          // Testing / Sandbox reset option
          if (sub.isPro) ...[
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.cancel_outlined, color: AppColors.error),
                title: const Text('Aboneliği İptal Et / Sıfırla (Sandbox Test)'),
                subtitle: const Text('Abonelik durumunu ücretsiz plana çevirir', style: TextStyle(fontSize: 12)),
                onTap: () async {
                  await ref.read(subscriptionProvider.notifier).cancelSubscription();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abonelik sıfırlandı (Ücretsiz moda geçildi).')),
                    );
                  }
                },
              ),
            ),
          ],

          const SizedBox(height: 28),

          // App version & branding
          Center(
            child: Column(
              children: const [
                Text(
                  'YDS Master PRO • Sürüm 1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'ÖSYM YDS Sınavlarına Hazırlık Platformu',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
