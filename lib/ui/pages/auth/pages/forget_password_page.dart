import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/forget_password_header.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../graphql/mutations/auth_mutations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import l10n

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  // Your GraphQL mutation string remains here
  final String forgetPasswordMutation = '''
    mutation ForgetPassword(\$userEmail: String!) {
      forgetPassword(userEmail: \$userEmail) {
        message
        status
      }
    }
  ''';

  void _resetPassword() async {
    final l10n = S.of(context)!; // Access l10n here for messages

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GraphQLClient client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(forgetPasswordMutation),
        variables: {
          'userEmail': _emailController.text,
        },
      );

      final result = await client.mutate(options);

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result.hasException) {
        // Reusing localization key for generic GraphQL errors or a specific one
        _showErrorSnackBar(result.exception?.graphqlErrors.first.message ??
            l10n.verificationGraphQLErrorDefault); // Or l10n.defaultError
      } else {
        _showResetConfirmationSnackBar();
        // Store email in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);
        AppRoutes.navigateToVerifyPasswordReset(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Using a specific localized unexpected error for this page
        _showErrorSnackBar(l10n.unexpectedPasswordResetVerificationError);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    // You could replicate the enhanced snackbar style from AuthService here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), // The message is already localized
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResetConfirmationSnackBar() {
    final l10n = S.of(context)!; // Access l10n here

    // You could replicate the enhanced snackbar style from AuthService here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(l10n.passwordResetOtpSentMessage), // Use localized message
        backgroundColor: Colors.green,
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
                // Assuming ForgetPasswordHeader handles its own localization
                const ForgetPasswordHeader(),
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: l10n.emailHintText, // Use localized hint
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            final l10n = S
                                .of(context)!; // Access l10n here for validator
                            if (value == null || value.isEmpty) {
                              return l10n
                                  .enterEmailError; // Use localized message
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return l10n
                                  .invalidEmailError; // Use localized message
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _resetPassword,
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
                                    // Remove const
                                    l10n.resetPasswordButton, // Use localized button text
                                    style: const TextStyle(
                                      // Keep const for static style
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
                      // Remove const
                      l10n.rememberPasswordPrompt, // Use localized prompt
                      style: const TextStyle(
                          color: Colors.white70), // Keep const for static style
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/login'); // Using named route directly
                      },
                      child: Text(
                        // Remove const
                        l10n.signInLink, // Use localized link text
                        style: const TextStyle(
                          // Keep const for static style
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
    _emailController.dispose();
    super.dispose();
  }
}
