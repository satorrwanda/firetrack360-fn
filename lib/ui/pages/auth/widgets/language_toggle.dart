import 'package:flutter/material.dart';

class LanguageToggle extends StatelessWidget {
  final Function(Locale) onLanguageChanged;
  final Locale currentLocale;
  final List<Locale> supportedLocales;
  final Map<String, String> languageNames;

  const LanguageToggle({
    super.key,
    required this.onLanguageChanged,
    required this.currentLocale,
    required this.supportedLocales,
    this.languageNames = const {
      'en': 'English',
      'fr': 'Français',
      'rw': 'Kinyarwanda',
    },
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              _showLanguageMenu(context);
            },
            tooltip: 'Change Language',
          ),
          Text(
            languageNames[currentLocale.languageCode] ??
                currentLocale.languageCode,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<Locale>(
      context: context,
      position: position,
      items: supportedLocales.map((locale) {
        return PopupMenuItem<Locale>(
          value: locale,
          child: Row(
            children: [
              Text(
                languageNames[locale.languageCode] ?? locale.languageCode,
                style: TextStyle(
                  fontWeight: currentLocale.languageCode == locale.languageCode
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              if (currentLocale.languageCode == locale.languageCode)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.check, size: 18),
                ),
            ],
          ),
        );
      }).toList(),
    ).then((selectedLocale) {
      if (selectedLocale != null) {
        onLanguageChanged(selectedLocale);
      }
    });
  }
}
