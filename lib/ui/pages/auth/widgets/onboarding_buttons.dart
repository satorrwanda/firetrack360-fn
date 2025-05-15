import 'package:firetrack360/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/ui/pages/auth/widgets/language_toggle.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/routes/app_routes.dart';

class OnboardingButtons extends ConsumerWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;
  final bool isVertical;

  const OnboardingButtons({
    super.key,
    required this.onRegister,
    required this.onLogin,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the localeProvider here to trigger rebuilds if needed
    ref.watch(localeProvider);

    final l10n = S.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    // Common button styles
    final registerButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.deepPurple.shade700,
      elevation: 2,
      shadowColor: Colors.deepPurple.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );

    final loginButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: Colors.white, width: 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );

    // Language toggler widget
    final languageToggler = Align(
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
    );

    // Register button widget
    final registerButton = ElevatedButton(
      onPressed: onRegister,
      style: registerButtonStyle,
      child: Text(
        l10n.register,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );

    // Login button widget
    final loginButton = OutlinedButton(
      onPressed: onLogin,
      style: loginButtonStyle,
      child: Text(
        l10n.login,
        style: const TextStyle(
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    );

    // Terms and conditions link
    final termsLink = TextButton(
      onPressed: () {
        AppRoutes.navigateToTerms(context);
      },
      child: Text(
        l10n.termsAndConditionsText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white70,
        ),
      ),
    );

    // Conditional layout based on isVertical parameter
    if (isVertical) {
      // Vertical layout for large screens (side by side)
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Language toggler at the top
            languageToggler,
            const SizedBox(height: 24),

            // Fixed width buttons for vertical layout
            SizedBox(
              width: 260, // Fixed width for better appearance
              height: 54,
              child: registerButton,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 260, // Fixed width for better appearance
              height: 54,
              child: loginButton,
            ),

            // Terms and conditions below buttons
            const SizedBox(height: 24),
            termsLink,
          ],
        ),
      );
    } else {
      // Original horizontal layout for mobile screens
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: Column(
          children: [
            // Language toggler at the top
            languageToggler,

            // Full width buttons for mobile layout
            SizedBox(
              height: 54,
              width: double.infinity,
              child: registerButton,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 54,
              width: double.infinity,
              child: loginButton,
            ),

            // Terms and conditions below buttons
            const SizedBox(height: 16),
            termsLink,
          ],
        ),
      );
    }
  }
}
