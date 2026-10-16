import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../providers/subscription_provider.dart';
import 'home/home_screen.dart';
import 'vocabulary/vocabulary_screen.dart';
import 'practice/practice_screen.dart';
import 'exam/exam_list_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sub = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      HomeScreen(onTabChange: _onTabChange),
      const VocabularyScreen(),
      const PracticeScreen(),
      const ExamListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabChange,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        indicatorColor: AppColors.primaryLight.withOpacity(0.15),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primaryLight),
            label: 'Ana Sayfa',
          ),
          const NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style, color: AppColors.primaryLight),
            label: 'Kelimeler',
          ),
          const NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz, color: AppColors.primaryLight),
            label: 'Sorular',
          ),
          const NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer, color: AppColors.primaryLight),
            label: 'Denemeler',
          ),
          NavigationDestination(
            icon: Icon(
              sub.isPro ? Icons.workspace_premium : Icons.person_outline,
              color: sub.isPro ? AppColors.premiumGold : null,
            ),
            selectedIcon: Icon(
              sub.isPro ? Icons.workspace_premium : Icons.person,
              color: sub.isPro ? AppColors.premiumGold : AppColors.primaryLight,
            ),
            label: sub.isPro ? 'PRO Üye' : 'Profil',
          ),
        ],
      ),
    );
  }
}
