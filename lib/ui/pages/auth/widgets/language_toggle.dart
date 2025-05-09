import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageToggler extends StatefulWidget {
  const LanguageToggler({Key? key}) : super(key: key);

  @override
  State<LanguageToggler> createState() => _LanguageTogglerState();
}

class _LanguageTogglerState extends State<LanguageToggler> {
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    setState(() {
      _currentLocale = Locale(languageCode);
    });
  }

  Future<void> _changeLanguage(Locale newLocale) async {
    if (newLocale != _currentLocale) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);

      // Force a rebuild of the MaterialApp with new locale
      final widget = context.findAncestorWidgetOfExactType<MaterialApp>();
      if (widget != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.home!,
          ),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: _currentLocale ?? const Locale('en'),
      icon: const Icon(Icons.language, color: Colors.white),
      dropdownColor: Colors.deepPurple.shade700,
      style: const TextStyle(color: Colors.white),
      underline: Container(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          _changeLanguage(newLocale);
        }
      },
      items: AppLocalizations.supportedLocales.map((Locale locale) {
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(
            _getLanguageName(locale.languageCode),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
