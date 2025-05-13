import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageToggler extends ConsumerStatefulWidget {
  const LanguageToggler({super.key});

  @override
  ConsumerState<LanguageToggler> createState() => _LanguageTogglerState();
}

class _LanguageTogglerState extends ConsumerState<LanguageToggler> {
  bool _isChangingLocale = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);

    // Show loading indicator while locale is changing
    if (_isChangingLocale) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return DropdownButton<String>(
      value: currentLocale.languageCode,
      icon: const Icon(Icons.language, color: Colors.white),
      dropdownColor: Colors.deepPurple.shade700,
      style: const TextStyle(color: Colors.white),
      underline: Container(),
      onChanged: (String? newValue) async {
        if (newValue != null && !_isChangingLocale) {
          setState(() {
            _isChangingLocale = true;
          });

          try {
            // This will load translations and update the locale
            await ref.read(localeProvider.notifier).setLocale(Locale(newValue));
          } finally {
            if (mounted) {
              setState(() {
                _isChangingLocale = false;
              });
            }
          }
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
