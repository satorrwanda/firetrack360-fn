import 'package:flutter/material.dart';
import 'package:firetrack360/generated/l10n.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n here

    return Column(
      children: [
        // Icon with container
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.local_fire_department,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        // Create Account text with enhanced styling
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            // Remove const
            l10n.createAccountTitle, // Use localized string (you'll need to add this key)
            textAlign: TextAlign.center,
            style: TextStyle(
              // Removed const for dynamic style
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(2.0, 2.0),
                ),
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4.0, 4.0),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Sign up text with container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Text(
            // Remove const
            l10n.signUpToGetStartedSubtitle, // Use localized string (you'll need to add this key)
            textAlign: TextAlign.center,
            style: TextStyle(
              // Keep TextStyle for dynamic opacity
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
