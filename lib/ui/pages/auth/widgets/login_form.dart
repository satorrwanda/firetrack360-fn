import 'package:firetrack360/graphql/mutations/auth_mutations.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import l10n

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _performLogin() async {
    final l10n = S.of(context)!; // Access l10n here for messages

    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          },
        ),
      );

      if (result.hasException) {
        final errorMessage = result.exception?.graphqlErrors.first.message ??
            l10n.loginFailedDefaultError; // Use localized fallback
        _showErrorSnackBar(errorMessage);
        if (errorMessage == l10n.emailVerificationRequiredError) {
          // Compare with localized string
          AppRoutes.navigateToActivateAccount(context);
        }
        return;
      }

      final loginResult = result.data?['login'];
      if (loginResult['status'] == 200) {
        if (mounted) {
          _showSuccessSnackBar(
              l10n.loginSuccessfulMessage); // Use localized message

          // Store email and verify storage
          final prefs = await SharedPreferences.getInstance();
          final email = _emailController.text.trim();
          await prefs.setString('email', email);

          // Double-check email was stored correctly
          final storedEmail = prefs.getString('email');
          if (storedEmail == null || storedEmail != email) {
            _showErrorSnackBar(
                l10n.emailSaveFailedError); // Use localized message
            return;
          }

          AppRoutes.navigateToVerifyLogin(context);
        }
      } else {
        // If the server provides a specific message, use it, otherwise use the localized fallback
        _showErrorSnackBar(
            loginResult['message'] ?? l10n.loginFailedDefaultError);
      }
    } catch (e) {
      _showErrorSnackBar(l10n.unexpectedError); // Use localized message
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateInputs() {
    final l10n = S.of(context)!; // Access l10n here for messages

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar(l10n.fillAllFieldsError); // Use localized message
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      _showErrorSnackBar(l10n.invalidEmailError); // Use localized message
      return false;
    }
    return true;
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
                    message)), // This message is already localized string passed from _performLogin
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
                    message)), // This message is already localized string passed from _performLogin or _validateInputs
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n here for UI texts

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _emailController,
            hint: l10n.emailHintText, // Use localized hint
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _passwordController,
            hint: l10n.passwordHintText, // Use localized hint
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => AppRoutes.navigateToForgetPassword(context),
              child: Text(
                // Remove const
                l10n.forgotPasswordLink, // Use localized text
                style: TextStyle(
                  color: Colors.deepPurple.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _performLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    // Remove const
                    l10n.login
                        .toUpperCase(), // Use localized text and convert to uppercase
                    style: const TextStyle(
                      // Keep const for static style
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint, // This hint is now expected to be a localized string
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        suffixIcon: suffixIcon,
        hintText: hint, // The localized hint string is used directly here
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
