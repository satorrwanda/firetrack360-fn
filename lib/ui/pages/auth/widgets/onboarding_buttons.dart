import 'package:firetrack360/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/ui/pages/auth/widgets/language_toggle.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import l10n

class OnboardingButtons extends ConsumerWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const OnboardingButtons({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the localeProvider here to trigger rebuilds if needed,
    // although S.of(context)! should handle most cases after MaterialApp locale change.
    ref.watch(localeProvider);

    final l10n = S.of(context)!; // Access l10n here

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
      child: Column(
        children: [
          // Language toggler positioned above buttons
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade700.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: LanguageToggler(),
              ),
            ),
          ),

          // Register button
          ElevatedButton(
            onPressed: onRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepPurple.shade700,
              minimumSize: const Size(double.infinity, 54),
              elevation: 2,
              shadowColor: Colors.deepPurple.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              // Use Text instead of const Text
              l10n.register, // Use the localized string
              style: const TextStyle(
                // Keep const TextStyle if style is static
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Login button
          OutlinedButton(
            onPressed: onLogin,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1.5),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              // Use Text instead of const Text
              l10n.login, // Use the localized string
              style: const TextStyle(
                // Keep const TextStyle if style is static
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
