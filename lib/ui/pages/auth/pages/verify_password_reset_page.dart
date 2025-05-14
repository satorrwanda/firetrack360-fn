import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import l10n

class VerifyPasswordResetPage extends StatefulWidget {
  const VerifyPasswordResetPage({super.key});

  @override
  _VerifyPasswordResetPageState createState() =>
      _VerifyPasswordResetPageState();
}

class _VerifyPasswordResetPageState extends State<VerifyPasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String _email =
      ''; // This will be populated by _getEmailFromSharedPreferences

  // Your GraphQL mutation string remains here
  final String verifyPasswordForgetMutation = '''
    mutation VerifyPasswordForget(\$email: String!, \$otp: String!) {
      verifyPasswordForget(
        verificationFields: {
          email: \$email,
          otp: \$otp
        }
      ) {
        message
        status
        verificationToken
      }
    }
  ''';

  void _verifyOTP() async {
    final l10n = S.of(context)!; // Access l10n here for messages

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GraphQLClient client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(verifyPasswordForgetMutation),
        variables: {
          'email': _email, // Use the email populated by FutureBuilder
          'otp': _otpController.text,
        },
      );

      final result = await client.mutate(options);

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result.hasException) {
        // Reusing localization key from AuthService for GraphQL errors
        _showErrorSnackBar(result.exception?.graphqlErrors.first.message ??
            l10n.verificationGraphQLErrorDefault);
      } else {
        final String? verificationToken =
            result.data?['verifyPasswordForget']['verificationToken'];
        if (verificationToken != null) {
          // Store verification token in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('verificationToken', verificationToken);
          // Navigate to reset password page with the verification token
          if (mounted) {
            // You might want a success snackbar here
            // _showSuccessSnackBar(l10n.passwordResetVerificationSuccessMessage); // Add a key for this
            AppRoutes.navigateToResetPassword(context);
          }
        } else {
          // Handle cases where verificationToken is null but no exception
          _showErrorSnackBar(l10n
              .verificationFailedDefault); // Reuse verification failed default
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Use localized unexpected error
        _showErrorSnackBar(l10n
            .unexpectedPasswordResetVerificationError); 
      }
    }
  }

  void _showErrorSnackBar(String message) {
    // Using a simple snackbar here. If you prefer the enhanced style
    // from AuthService, you would call AuthService()._showErrorSnackBar(context, message)
    // and ensure AuthService has access to BuildContext.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), // The message is already localized
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n here for UI texts

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
                FutureBuilder<String>(
                  future: _getEmailFromSharedPreferences(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Consider localizing loading text if needed
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Use localized error prefix
                      return Text(
                          '${l10n.futureBuilderErrorPrefix}${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      _email = snapshot.data!; // Populate _email state variable
                      // Masking email logic
                      final localPart = _email.split('@').first;
                      String maskedLocal = localPart;
                      if (localPart.length > 5) {
                        maskedLocal = localPart.substring(0, 3) +
                            '*' * (localPart.length - 5) +
                            localPart.substring(localPart.length - 2);
                      } else if (localPart.length > 3) {
                        maskedLocal = localPart.substring(0, 3) +
                            '*' * (localPart.length - 3);
                      }

                      // Masking for domain (reusing logic from VerifyLoginPage)
                      final domain = _email.split('@').last;
                      String maskedDomain = domain;
                      final domainParts = domain.split('.');
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
                        maskedDomain =
                            domain.substring(0, 3) + '*' * (domain.length - 3);
                      }

                      return Text(
                        l10n.enterOtpMessage(
                            '${maskedLocal}@${maskedDomain}'), 
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      );
                    } else {
                      // Handle case where no email is found after loading
                      // This might indicate a navigation issue or a previous error.
                      // You might want to show a specific message or navigate back.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Navigate back to forget password or login
                        AppRoutes.navigateToForgetPassword(context);
                      });
                      return const SizedBox
                          .shrink(); // Or a message like l10n.emailNotFoundError
                    }
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
                            hintText: l10n.otpHintText, 
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
                                .of(context)!; 
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
                            onPressed: _isLoading ? null : _verifyOTP,
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
                      l10n.didNotReceiveCodePrompt,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.navigateToForgetPassword(
                            context); 
                      },
                      child: Text(
                        l10n.resendLink, 
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

  Future<String> _getEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }
}
