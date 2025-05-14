import 'package:firetrack360/graphql/mutations/auth_mutations.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _email = '';
  String _verificationToken = '';

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? '';
      _verificationToken = prefs.getString('verificationToken') ?? '';
    });
  }

  String? _validatePassword(String? value) {
    final l10n = S.of(context);
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 8) {
      return l10n.passwordLengthError;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordUppercaseError;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return l10n.passwordLowercaseError;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.passwordNumberError;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return l10n.passwordSpecialCharError;
    }
    return null;
  }

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GraphQLClient client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(replaceForgotPasswordMutation),
        variables: {
          'newPassword': _passwordController.text,
          'confirmPassword': _confirmPasswordController.text,
          'email': _email,
          'verificationToken': _verificationToken,
        },
      );

      final result = await client.mutate(options);

      if (mounted) {
        setState(() => _isLoading = false);
      }

      if (result.hasException) {
        _showErrorSnackBar(result.exception?.graphqlErrors.first.message ??
            S.of(context).genericError);
      } else {
        _showSuccessSnackBar();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(S.of(context).unexpectedError);
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

  void _showSuccessSnackBar() {
    final l10n = S.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.passwordResetSuccess),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: l10n.login,
          onPressed: () {
            Navigator.of(context).pop();
            AppRoutes.navigateToLogin(context);
          },
        ),
      ),
    );
    AppRoutes.navigateToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

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
                  l10n.resetPasswordTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.resetPasswordSubtitle,
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
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: l10n.newPasswordHint,
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.deepPurple),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            hintText: l10n.confirmPasswordHint,
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.deepPurple),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return l10n.passwordMismatchError;
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
                                : Text(l10n.resetPasswordButton),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
