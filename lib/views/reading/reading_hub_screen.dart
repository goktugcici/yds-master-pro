import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/seed_readings.dart';
import '../../providers/subscription_provider.dart';
import '../paywall/paywall_screen.dart';
import 'reading_detail_screen.dart';

class ReadingHubScreen extends ConsumerWidget {
  const ReadingHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final articles = defaultReadingArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('YDS Reading Atölyesi'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Akademik Metinlerle YDS Reading',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tıp, Biyoloji, Ekonomi, Tarih ve Arkeoloji metinlerini çevirileri ve kelime analizleriyle okuyun.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Seçkin Akademik Makaleler',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...articles.map((art) {
            final isLocked = art.isProOnly && !sub.isPro;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        art.topic,
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      art.level,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Spacer(),
                    if (isLocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.premiumGold,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        art.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${art.readTimeMinutes} dk okuma',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 14),
                          const Icon(Icons.spellcheck, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${art.vocabulary.length} Kritik Kelime',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                trailing: Icon(
                  isLocked ? Icons.lock : Icons.arrow_forward_ios,
                  size: 16,
                  color: isLocked ? AppColors.premiumGold : Colors.grey,
                ),
                onTap: () {
                  if (isLocked) {
                    PaywallScreen.show(context);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ReadingDetailScreen(article: art),
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
