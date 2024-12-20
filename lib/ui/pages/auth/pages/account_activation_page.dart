import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AccountActivationPage extends StatefulWidget {
  const AccountActivationPage({super.key});

  @override
  State<AccountActivationPage> createState() => _AccountActivationPageState();
}

class _AccountActivationPageState extends State<AccountActivationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String _email = '';
  
  Timer? _resendTimer;
  int _remainingTime = 0;
  int _resendCount = 0;
  static const int _maxResendAttempts = 3;
  static const int _resendInterval = 60;

  String _maskEmail(String email) {
    if (email.isEmpty) return '';
    
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final localPart = parts[0];
    final domain = parts[1];

    String maskedLocal = localPart;
    if (localPart.length > 5) {
      maskedLocal = localPart.substring(0, 3) + 
                    '*' * (localPart.length - 5) + 
                    localPart.substring(localPart.length - 2);
    } else if (localPart.length > 3) {
      maskedLocal = localPart.substring(0, 3) + 
                    '*' * (localPart.length - 3);
    }

    final domainParts = domain.split('.');
    String maskedDomain = domain;
    if (domainParts.length > 1) {
      final tld = domainParts.last;
      final domainName = domainParts.first;
      if (domainName.length > 3) {
        maskedDomain = '${domainName.substring(0, 3)}${'*' * (domainName.length - 3)}.$tld';
      }
    }

    return '$maskedLocal@$maskedDomain';
  }

  Future<void> _verifyAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final result = await authService.verifyAccount(
        email: _email,
        otp: _otpController.text,
        context: context,
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result) {
        if (mounted) {
          AppRoutes.navigateToLogin(context);
        }
      } else {
        _showError('Account verification failed. Please check your verification code and try again.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('An unexpected error occurred');
      }
    }
  }

  Future<void> _resendVerificationOtp() async {
    if (_remainingTime > 0 || _resendCount >= _maxResendAttempts) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final result = await authService.resendVerificationOtp(
        email: _email,
        context: context,
      );

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result) {
        setState(() {
          _resendCount++;
          _remainingTime = _resendInterval;
        });
        _startResendTimer();
        _showSuccess('Verification code has been resent successfully.');
      } else {
        _showError('Failed to resend verification code. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('An unexpected error occurred');
      }
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
      }
    });
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String> _getEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
                  'Activate Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<String>(
                  future: _getEmailFromSharedPreferences(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(
                        color: Colors.white,
                      ));
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      );
                    } else if (snapshot.hasData) {
                      _email = snapshot.data!;
                      return Text(
                        'Enter the verification code sent to\n${_maskEmail(_email)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      );
                    }
                    return Container();
                  },
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
                            hintText: 'Enter 6-digit verification code',
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
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
                              return 'Please enter the verification code';
                            }
                            if (value.length != 6) {
                              return 'Verification code must be 6 digits';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'Verification code must contain only numbers';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: (_remainingTime > 0 || _resendCount >= _maxResendAttempts || _isLoading) 
                              ? null 
                              : _resendVerificationOtp,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                          ),
                          child: Text(
                            _remainingTime > 0
                                ? 'Resend code in ${_remainingTime}s'
                                : _resendCount >= _maxResendAttempts
                                    ? 'Maximum resend attempts reached'
                                    : 'Resend verification code (${_maxResendAttempts - _resendCount} attempts left)',
                            style: TextStyle(
                              color: (_remainingTime > 0 || _resendCount >= _maxResendAttempts || _isLoading)
                                  ? Colors.grey
                                  : Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyAccount,
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
                                : const Text('Activate Account'),
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
                      'Already activated? ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () => AppRoutes.navigateToLogin(context),
                      child: const Text(
                        'Sign In',
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
}