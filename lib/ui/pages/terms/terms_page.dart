import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TermsPage extends HookConsumerWidget {
  const TermsPage({Key? key}) : super(key: key);

  Future<String> loadTermsText(Locale currentLocale) async {
    final localeCode = currentLocale.languageCode;
    debugPrint("Doc locale: $localeCode");

    try {
      return await rootBundle.loadString('assets/terms/terms_$localeCode.md');
    } catch (e) {
      debugPrint('Failed to load localized terms for locale $localeCode: $e');
      try {
        return await rootBundle.loadString('assets/terms/terms_en.md');
      } catch (e2) {
        debugPrint('Failed to load default English terms: $e2');
        return 'Error loading terms content.';
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale =
        ref.watch(localeProvider); // Access the locale property
    final l10n = S.of(context)!;
    final supportedLocales =
        S.supportedLocales; // Correct way to access supported locales

    final termsTextFuture = useMemoized(
      () => loadTermsText(currentLocale),
      [currentLocale],
    );
    final termsTextSnapshot = useFuture(termsTextFuture);

    return Scaffold(
      // Set scaffold background color or use the same gradient as Onboarding
      backgroundColor: Colors.deepPurple.shade800, // Example dark background
      appBar: AppBar(
        title: Text(l10n.termsPageTitle),
        backgroundColor: Colors.deepPurple.shade700, // Darker shade for AppBar
        foregroundColor:
            Colors.white, // Set AppBar title and icon color to white
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton<Locale>(
              dropdownColor: Colors.deepPurple.shade700,
              iconEnabledColor: Colors.white,
              underline: const SizedBox(),
              value: currentLocale,
              items: supportedLocales.map((Locale locale) {
                String languageName = locale.languageCode.toUpperCase();
                if (locale.languageCode == 'en') {
                  languageName = 'English';
                } else if (locale.languageCode == 'fr') {
                  languageName = 'Français';
                } else if (locale.languageCode == 'rw') {
                  languageName = 'Kinyarwanda';
                }

                return DropdownMenuItem<Locale>(
                  value: locale,
                  child: Text(
                    languageName,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  ref.read(localeProvider.notifier).setLocale(newLocale);
                }
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (termsTextSnapshot.connectionState == ConnectionState.done) {
            if (termsTextSnapshot.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: MarkdownBody(
                  data: termsTextSnapshot.data!,
                  styleSheet: MarkdownStyleSheet(
                    // Adjust text colors for dark background
                    p: const TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                        color: Colors.white70), // Lighter text
                    h1: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white), // White headings
                    h2: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white), // White headings
                    // You might need to style other elements like lists, links, etc.
                    // Here are some examples:
                    // listIndent: 20.0, // Adjust indentation for lists
                    // li: const TextStyle(fontSize: 16.0, height: 1.5, color: Colors.white70),
                    // a: const TextStyle(color: Colors.blueAccent), // Link color for dark mode
                  ),
                  onTapLink: (text, href, title) {
                    // Handle links if needed
                  },
                ),
              );
            } else if (termsTextSnapshot.hasError) {
              return Center(
                child: Text(
                  '${l10n.errorLoadingTerms}: ${termsTextSnapshot.error}',
                  style: const TextStyle(
                      color: Colors.white70), // Style error text
                ),
              );
            }
          }
          // Loading indicator color is already set to a deep purple shade
          return Center(
              child: CircularProgressIndicator(
                  color: Colors
                      .deepPurple.shade300)); // Lighter shade might be better
        },
      ),
    );
  }
}
