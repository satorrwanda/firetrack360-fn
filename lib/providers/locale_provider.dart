import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/generated/l10n.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('languageCode');
      if (languageCode != null) {
        final newLocale = Locale(languageCode);
        await _loadTranslations(newLocale);
        state = newLocale;
      }
    } catch (e) {
      debugPrint('Error loading locale: $e');
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (state.languageCode != newLocale.languageCode) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('languageCode', newLocale.languageCode);
        await _loadTranslations(newLocale);
        state = newLocale;
      } catch (e) {
        debugPrint('Error setting locale: $e');
      }
    }
  }

  Future<void> _loadTranslations(Locale locale) async {
    await S.delegate.load(locale);
    debugPrint('Translations loaded for: ${locale.languageCode}');
  }
}
