import 'package:flutter/material.dart';

class OnboardingButtons extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const OnboardingButtons({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
      child: Column(
        children: [
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
            child: const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
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
            child: const Text(
              'Already have an account? Login',
              style: TextStyle(
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