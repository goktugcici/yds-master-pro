import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_provider.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref _ref;

  ThemeModeNotifier(this._ref) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    final storage = _ref.read(localStorageProvider);
    state = storage.isDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final storage = _ref.read(localStorageProvider);
    final isDark = state == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await storage.setDarkMode(!isDark);
    state = newMode;
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref);
});
