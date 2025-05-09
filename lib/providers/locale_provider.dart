import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  // Default to English
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('languageCode');
      if (languageCode != null) {
        state = Locale(languageCode);
      }
    } catch (e) {
      debugPrint('Error loading locale: $e');
      // Keep default locale (en) if there's an error
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    try {
      // Only update if it's a different locale
      if (state.languageCode != newLocale.languageCode) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('languageCode', newLocale.languageCode);
        state = newLocale;
        debugPrint('Locale set to: ${newLocale.languageCode}');
      }
    } catch (e) {
      debugPrint('Error setting locale: $e');
    }
  }
}
