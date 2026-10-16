import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'data/local_storage.dart';
import 'providers/local_storage_provider.dart';
import 'providers/theme_provider.dart';
import 'views/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent storage
  final storage = await LocalStorage.init();

  // Update daily streak
  await storage.checkAndUpdateStreak();

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
      child: const YdsApp(),
    ),
  );
}

class YdsApp extends ConsumerWidget {
  const YdsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'YDS Master PRO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainNavigationScreen(),
    );
  }
}
