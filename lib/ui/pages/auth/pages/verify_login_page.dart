import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/generated/l10n.dart';

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
    // No longer calling _loadCredentials here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call _loadCredentials here after dependencies are ready
    _loadCredentials();
  }

  // --- Helper method to mask email (moved up) ---
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
            '${domainName.substring(0, 3)}${'*' * (domainName.length - 3)}.${tld}';
      } else {
        maskedDomain = domainName +
            '*' * (domain.length - domainName.length - 1) +
            '.' +
            tld;
      }
    } else if (domain.length > 3) {
      maskedDomain = domain.substring(0, 3) + '*' * (domain.length - 3);
    }

    return '$maskedLocal@$maskedDomain';
  }
  // --- End Helper method ---

  Future<void> _loadCredentials() async {
    // Access l10n here is safe in didChangeDependencies
    final l10n = S.of(context)!;

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');

      if (email == null || email.isEmpty) {
        _showErrorAndNavigateToLogin(
            l10n.noEmailFoundError); // Use localized message
        return;
      }

      setState(() {
        _email = email;
        _isEmailValid = _isValidEmail(email);
      });

      if (!_isEmailValid) {
        _showErrorAndNavigateToLogin(
            l10n.invalidEmailVerificationError); // Use localized message
      }
    } catch (e) {
      _showErrorAndNavigateToLogin(
          l10n.errorRetrievingEmailError); // Use localized message
    }
  }

  // Email validation method
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    if (email.isEmpty) return false;
    if (email.length > 254) return false;
    if (email.contains('..')) return false;
    return emailRegex.hasMatch(email);
  }

  void _showErrorAndNavigateToLogin(String message) {
    // Using a post-frame callback to show the snackbar after the build cycle
    // completes, preventing potential issues with context during navigation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Check if the widget is still mounted
        _showErrorSnackBar(message); // Use the local error snackbar
        AppRoutes.navigateToLogin(context);
      }
    });
  }

  Future<void> _verifyLogin() async {
    final l10n = S.of(context)!; // Access l10n here

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      if (email.isEmpty) {
        if (mounted) {
          _showErrorSnackBar(l10n.noEmailFoundError); // Use localized message
          setState(() => _isLoading = false);
        }
        return;
      }

      final AuthService authService = AuthService();
      final result = await authService.verifyLogin(
          context: context, email: email, otp: _otpController.text);

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result.hasException) {
        if (mounted) {
          _showErrorSnackBar(result.exception?.graphqlErrors.first.message ??
              l10n.verificationGraphQLErrorDefault); // Use localized fallback
        }
        return;
      }

      final loginResult = result.data?['verifyLogin'];
      if (loginResult != null && loginResult['status'] == 200) {
        final String? accessToken = loginResult['accessToken'];
        final String? refreshToken = loginResult['refreshToken'];

        if (accessToken != null && refreshToken != null) {
          // Store tokens (AuthService handles localization of this step's messages if implemented)
          // If AuthService saves tokens and shows a success message internally,
          // you might not need a success snackbar here. If you want a specific
          // snackbar on THIS page, you can add it and use _showSuccessSnackBar.
          // _showSuccessSnackBar(l10n.verificationSuccessfulMessage); // Add a key for this if needed

          // Navigate to home page
          if (mounted) {
            AppRoutes.navigateToHome(context);
          }
        } else {
          if (mounted) {
            _showErrorSnackBar(
                l10n.invalidLoginResponseError); // Use localized message
          }
        }
      } else {
        if (mounted) {
          _showErrorSnackBar(loginResult?['message'] ??
              l10n.verificationFailedDefault); // Use localized fallback
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(l10n.unexpectedVerificationError(
            e.toString())); // Use localized message with placeholder
      }
    }
  }

  // --- Local SnackBar methods using localized strings ---
  void _showSuccessSnackBar(String message) {
    // Ensure context is valid before accessing l10n and showing snackbar
    if (!mounted) return;
    final l10n = S.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.successSnackBarTitle, // Use localized title
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message, // This message is already localized
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF00A36C),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l10n.dismissSnackBarAction, // Use localized action label
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    // Ensure context is valid before accessing l10n and showing snackbar
    if (!mounted) return;
    final l10n = S.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.errorSnackBarTitle, // Use localized title
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message, // This message is already localized
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l10n.dismissSnackBarAction, // Use localized action label
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  // --- End Local SnackBar methods ---

  @override
  Widget build(BuildContext context) {
    // Access l10n here for UI texts is always safe
    final l10n = S.of(context)!;

    if (_email.isEmpty && !_isLoading) {
      // Added _isLoading check
      // Show a loading indicator while email is being fetched
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
        ),
        backgroundColor: Colors.deepPurple,
      );
    }

    // If email fetching failed and we navigated away, we shouldn't build the rest of the page.
    // The _showErrorAndNavigateToLogin handles the navigation. If it returns,
    // we should probably not build the form. A simple check for _email being empty
    // after _loadCredentials has been called should be sufficient.
    if (_email.isEmpty) {
      // This case should ideally not be reached if _showErrorAndNavigateToLogin
      // is called correctly, but as a fallback, show an error or go back.
      return Scaffold(
        body: Center(
          child: Text(
            l10n.errorLoadingPage, // Localized error message
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.deepPurple,
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
                Text(
                  l10n.verifyOtpTitle, // Use localized title
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isEmailValid // Only mask if email is considered valid
                      ? l10n.enterOtpMessage(_maskEmail(
                          _email)) // Use localized message with placeholder
                      : l10n.enterOtpMessage(
                          _email), // Show full email if not valid (optional, based on desired UX)
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
                            hintText: l10n.otpHintText, // Use localized hint
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
                            final l10n = S
                                .of(context)!; // Access l10n here for validator

                            if (value == null || value.isEmpty) {
                              return l10n
                                  .enterOtpError; // Use localized message
                            }
                            if (value.length != 6) {
                              return l10n
                                  .otpLengthError; // Use localized message
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return l10n
                                  .otpNumbersOnlyError; // Use localized message
                            }
                            return null; // Return null if validation passes
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
                                : Text(
                                    l10n.verifyCodeButton, // Use localized button text
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
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
                    Text(
                      l10n.didNotReceiveCodePrompt, // Use localized prompt
                      style: const TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Optionally, call AuthService to resend OTP
                        // AuthService().resendVerificationOtp(context: context, email: _email);
                        // Then navigate or update UI
                        AppRoutes.navigateToLogin(
                            context); // Navigating to login on tap
                      },
                      child: Text(
                        l10n.resendLink, // Use localized link text
                        style: const TextStyle(
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

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
