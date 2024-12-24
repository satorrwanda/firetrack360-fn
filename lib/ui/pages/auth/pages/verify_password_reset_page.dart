import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPasswordResetPage extends StatefulWidget {
  const VerifyPasswordResetPage({super.key});

  @override
  _VerifyPasswordResetPageState createState() => _VerifyPasswordResetPageState();
}

class _VerifyPasswordResetPageState extends State<VerifyPasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  String _email = '';

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GraphQLClient client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(verifyPasswordForgetMutation),
        variables: {
          'email': _email,
          'otp': _otpController.text,
        },
      );

      final result = await client.mutate(options);

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result.hasException) {
        _showErrorSnackBar(result.exception?.graphqlErrors.first.message ?? 'An error occurred');
      } else {
        final String? verificationToken = result.data?['verifyPasswordForget']['verificationToken'];
        if (verificationToken != null) {
          // Store verification token in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('verificationToken', verificationToken);
          // Navigate to reset password page with the verification token
          if (mounted) {
            AppRoutes.navigateToResetPassword(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('An unexpected error occurred');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
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
                  'Verify OTP',
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      _email = snapshot.data!;
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

                      // No masking for domain
                      final domain = _email.split('@').last;

                      return Text(
                        'Enter the verification code sent to\n$maskedLocal@$domain',
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
                            hintText: 'Enter 6-digit OTP',
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
                        AppRoutes.navigateToForgetPassword(context);
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