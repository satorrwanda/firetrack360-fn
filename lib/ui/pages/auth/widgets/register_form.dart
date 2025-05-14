import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import l10n

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  CountryCode _selectedCountry = CountryCode.fromCountryCode('RW');

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Localized Validator Methods ---

  String? _validatePhoneNumber(String? value) {
    final l10n = S.of(context)!; // Access l10n for validation messages

    if (value == null || value.isEmpty) {
      return l10n.enterPhoneNumberError; // Use localized message
    }

    if (_selectedCountry.dialCode == '+250') {
      if (value.length != 9) {
        return l10n.rwandaPhoneNumberLengthError; // Use localized message
      }
      if (!value.startsWith('7')) {
        return l10n.rwandaPhoneNumberStartError; // Use localized message
      }
    } else {
      if (value.length < 9) {
        return l10n.phoneNumberMinLengthError; // Use localized message
      }
      if (value.length > 10) {
        return l10n.phoneNumberMaxLengthError; // Use localized message
      }
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final l10n = S.of(context)!; // Access l10n for validation messages

    if (value == null || value.isEmpty) {
      return l10n.enterPasswordError; // Use localized message
    }
    if (value.length < 8) {
      return l10n.passwordMinLengthError; // Use localized message
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordUppercaseError; // Use localized message
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return l10n.passwordLowercaseError; // Use localized message
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.passwordDigitError; // Use localized message
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return l10n.passwordSpecialCharError; // Use localized message
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l10n = S.of(context)!; // Access l10n for validation messages

    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordError; // Use localized message
    }
    if (value != _passwordController.text) {
      return l10n.passwordsDoNotMatchError; // Use localized message
    }
    return null;
  }
  // --- End Localized Validator Methods ---

  Future<void> _registerUser() async {
    // Note: Validation messages are handled within _validate... methods

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final fullPhoneNumber =
          '${_selectedCountry.dialCode}${_phoneController.text}';

      // Assuming AuthService handles showing localized success/error messages internally
      // or accepts localized strings to display. If AuthService shows hardcoded
      // messages, you'll need to localize those within AuthService.
      final authService = AuthService();
      final success = await authService.registerUser(
        context: context,
        email: _emailController.text.trim(),
        phone: fullPhoneNumber.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success && mounted) {
        // Clear form if registration was successful
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        AppRoutes.navigateToActivateAccount(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n for UI texts

    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
              const SizedBox(height: 24),
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
                  // LOCALIZED EMAIL VALIDATOR HERE
                  if (value == null || value.isEmpty) {
                    return l10n.enterEmailError; // Use localized message
                  }

                  // Using a simple regex for email validation
                  final emailRegex = RegExp(
                    r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
                  );

                  if (!emailRegex.hasMatch(value)) {
                    return l10n.invalidEmailError; // Use localized message
                  }

                  return null; // Return null if validation passes
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    // Remove const
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      l10n.phoneNumberLabel, // Use localized label
                      style: const TextStyle(
                        // Keep const if style is static
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.public,
                                color: Colors.deepPurple,
                                size: 20,
                              ),
                              Expanded(
                                child: CountryCodePicker(
                                  onChanged: (country) {
                                    setState(() {
                                      _selectedCountry = country;
                                      _phoneController.clear();
                                    });
                                  },
                                  initialSelection: 'RW',
                                  favorite: const ['RW'],
                                  showFlag: true,
                                  showDropDownButton: true,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  dialogSize: const Size(320, 450),
                                  dialogBackgroundColor: Colors.white,
                                  dialogTextStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                  searchDecoration: InputDecoration(
                                    hintText: l10n
                                        .searchCountryHint, // Use localized hint
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    fillColor: Colors.grey.shade50,
                                    filled: true,
                                  ),
                                  barrierColor: Colors.black54,
                                  backgroundColor: Colors.transparent,
                                  boxDecoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator:
                              _validatePhoneNumber, // This validator uses localized messages
                          decoration: InputDecoration(
                            // Consider a more neutral hint here if you don't want the error message as a hint
                            hintText: l10n
                                .enterPhoneNumberError, // Using validation error key as hint for simplicity
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              child: Text(
                                _selectedCountry.dialCode ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: l10n.passwordHintText, // Use localized hint
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.deepPurple),
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
                validator:
                    _validatePassword, // This validator uses localized messages
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: l10n.confirmPasswordHintText, // Use localized hint
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.deepPurple),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
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
                validator:
                    _validateConfirmPassword, // This validator uses localized messages
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,
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
                          l10n.createAccountTitle, // Use localized button text
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
    );
  }
}
