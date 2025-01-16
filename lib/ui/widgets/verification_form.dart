import 'package:flutter/material.dart';

class VerificationForm extends StatelessWidget {
  final String? email;
  final bool isLoading;
  final int remainingTime;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String) onOTPComplete;
  final VoidCallback onResendOTP;

  const VerificationForm({
    super.key,
    required this.email,
    required this.isLoading,
    required this.remainingTime,
    required this.controllers,
    required this.focusNodes,
    required this.onOTPComplete,
    required this.onResendOTP,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Icon(
              Icons.security,
              size: 64,
              color: Color(0xFF6741D9),
            ),
            const SizedBox(height: 24),
            Text(
              'Two-Factor Authentication',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6741D9),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter the 6-digit code sent to your email\n${email ?? ""}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OTPInputField(
              controllers: controllers,
              focusNodes: focusNodes,
              onComplete: onOTPComplete,
            ),
            const SizedBox(height: 32),
            VerifyButton(
              isLoading: isLoading,
              onPressed: () {
                final otp = controllers.map((c) => c.text).join();
                onOTPComplete(otp);
              },
            ),
            const SizedBox(height: 24),
            ResendButton(
              isLoading: isLoading,
              remainingTime: remainingTime,
              onPressed: onResendOTP,
            ),
          ],
        ),
      ),
    );
  }
}
