import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/services/auth_service.dart';

class VerifyLoginPage extends StatefulWidget {
  const VerifyLoginPage({super.key});

  @override
  State<VerifyLoginPage> createState() => _VerifyLoginPageState();
}

class _VerifyLoginPageState extends State<VerifyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String _email = '';
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null || email.isEmpty) {
        // No email stored, navigate back to login
        _showErrorAndNavigateToLogin('No email found. Please log in again.');
        return;
      }

      setState(() {
        _email = email;
        _isEmailValid = _isValidEmail(email);
      });

      if (!_isEmailValid) {
        _showErrorAndNavigateToLogin('Invalid email. Please log in again.');
      }
    } catch (e) {
      _showErrorAndNavigateToLogin(
          'Error retrieving email. Please log in again.');
    }
  }

  // Email validation method
  bool _isValidEmail(String email) {
    // Comprehensive email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    // Additional checks
    if (email.isEmpty) return false;
    if (email.length > 254) return false; // RFC 5321
    if (email.contains('..')) return false; // No consecutive dots

    return emailRegex.hasMatch(email);
  }

  void _showErrorAndNavigateToLogin(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show error first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

      // Then navigate to login
      AppRoutes.navigateToLogin(context);
    });
  }

  Future<void> _verifyLogin() async {
    // Validate form before proceeding
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      if (email.isEmpty) {
        _showErrorSnackBar('Email not found. Please log in again.');
        return;
      }

      final AuthService authService = AuthService();
      final result = await authService.verifyLogin(
          context: context, email: email, otp: _otpController.text);

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result.hasException) {
        _showErrorSnackBar(result.exception?.graphqlErrors.first.message ??
            'An error occurred');
        return;
      }

      final loginResult = result.data?['verifyLogin'];
      if (loginResult['status'] == 200) {
        final String? accessToken = loginResult['accessToken'];
        final String? refreshToken = loginResult['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          // Store tokens in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await Future.wait([
            prefs.setString('accessToken', accessToken),
            prefs.setString('refreshToken', refreshToken),
          ]);

          // Navigate to home page
          if (mounted) {
            AppRoutes.navigateToHome(context);
          }
        } else {
          _showErrorSnackBar('Invalid login response');
        }
      } else {
        _showErrorSnackBar(loginResult['message'] ?? 'Verification failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('An unexpected error occurred: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If email is empty, return empty container or loading indicator
    if (_email.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => AppRoutes.navigateToLogin(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Verify OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter the verification code sent to\n${_maskEmail(_email)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: 'Enter 6-digit OTP',
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the OTP';
                            }
                            if (value.length != 6) {
                              return 'OTP must be 6 digits';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'OTP must contain only numbers';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Text('Verify Code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive the code? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.navigateToLogin(context);
                      },
                      child: const Text(
                        'Resend',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _maskEmail(String email) {
    if (email.isEmpty) return '';

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final localPart = parts[0];
    final domain = parts[1];

    // Keep first 3 and last 2 characters of local part, mask the rest
    String maskedLocal = localPart;
    if (localPart.length > 5) {
      maskedLocal = localPart.substring(0, 3) +
          '*' * (localPart.length - 5) +
          localPart.substring(localPart.length - 2);
    } else if (localPart.length > 3) {
      maskedLocal = localPart.substring(0, 3) + '*' * (localPart.length - 3);
    }

    // Mask domain except the TLD
    final domainParts = domain.split('.');
    String maskedDomain = domain;
    if (domainParts.length > 1) {
      final tld = domainParts.last;
      final domainName = domainParts.first;
      if (domainName.length > 3) {
        maskedDomain =
            '${domainName.substring(0, 3)}${'*' * (domainName.length - 3)}.$tld';
      }
    }

    return '$maskedLocal@$maskedDomain';
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
