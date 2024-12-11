import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/register_header.dart';
import '../widgets/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  CountryCode _selectedCountry = CountryCode.fromCountryCode('RW');
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  static const String registerMutation = '''
  mutation Register(\$email: String!, \$phone: String!, \$password: String!, \$confirmPassword: String!) {
    register(
      createUserInput: {
        email: \$email
        phone: \$phone
        password: \$password
        confirmPassword: \$confirmPassword
      }
    ) {
      status
      message
    }
  }
  ''';

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final String email = _emailController.text.trim();
    final String phone = _selectedCountry.dialCode! + _phoneController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    try {
      setState(() {
        _isLoading = true;
      });

      final client = GraphQLProvider.of(context).value;

      final MutationOptions options = MutationOptions(
        document: gql(registerMutation),
        variables: {
          'email': email,
          'phone': phone,
          'password': password,
          'confirmPassword': confirmPassword,
        },
        onCompleted: (dynamic resultData) async {
          if (resultData != null) {
            final registerResult = resultData['register'];
            if (registerResult['status'] == 201) {
              // Store email in shared preferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('email', email);

              _showSuccessSnackBar(registerResult['message'] ?? 'Account created successfully');
              Navigator.of(context).pushReplacementNamed('/activate-account');
            } else {
              _showErrorSnackBar(registerResult['message'] ?? 'Registration failed');
            }
          }
        },
        onError: (error) {
          _showErrorSnackBar('An error occurred: ${error.toString()}');
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        _showErrorSnackBar('Mutation error: ${result.exception.toString()}');
      }
    } catch (e) {
      _showErrorSnackBar('Unexpected error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RegisterHeader(),
                    const SizedBox(height: 40),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPhoneNumberField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 32),
                    _buildRegisterButton(),
                    const SizedBox(height: 24),
                    _buildLoginOption(),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            await _registerUser();
          } catch (e) {
            _showErrorSnackBar('An unexpected error occurred');
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'CREATE ACCOUNT',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }


  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade700,
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      hint: 'Email Address',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CountryCodePicker(
            onChanged: (CountryCode countryCode) {
              setState(() {
                _selectedCountry = countryCode;
              });
            },
            initialSelection: 'RW',
            favorite: const ['+250', 'RW'],
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            textStyle: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            controller: _phoneController,
            hint: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _passwordController,
      hint: 'Password',
      icon: Icons.lock_outline,
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!_isStrongPassword(value)) {
          return 'Password must include:\n'
              '• At least one uppercase letter\n'
              '• At least one lowercase letter\n'
              '• At least one number\n'
              '• At least one special character';
        }
        return null;
      },
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.white54,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      hint: 'Confirm Password',
      icon: Icons.lock_outline,
      obscureText: _obscureConfirmPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.white54,
        ),
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
      ),
    );
  }

  bool _isStrongPassword(String password) {
    final strongPasswordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return strongPasswordRegex.hasMatch(password);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildLoginOption() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Text(
        'Already have an account? Login',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
