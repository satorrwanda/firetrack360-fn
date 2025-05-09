import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageToggler extends ConsumerWidget {
  const LanguageToggler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return DropdownButton<String>(
      value: currentLocale.languageCode,
      icon: const Icon(Icons.language, color: Colors.white),
      dropdownColor: Colors.deepPurple.shade700,
      style: const TextStyle(color: Colors.white),
      underline: Container(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          ref.read(localeProvider.notifier).setLocale(Locale(newValue));
        }
      },
      items: S.supportedLocales.map((Locale locale) {
        return DropdownMenuItem<String>(
          value: locale.languageCode,
          child: Text(
            _getLanguageName(locale.languageCode),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'rw':
        return 'Kinyarwanda';
      default:
        return code.toUpperCase();
    }
  }
}
