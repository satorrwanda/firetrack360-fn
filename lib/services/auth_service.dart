import 'package:firetrack360/graphql/auth_mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> registerUser({
    required BuildContext context,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
       final prefs = await SharedPreferences.getInstance();
      final client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(registerMutation),
        variables: {
          'email': email,
          'phone': phone,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        final error = _handleGraphQLException(result.exception!);
        _showErrorSnackBar(context, error);
        return false;
      }

      final data = result.data?['register'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        _showSuccessSnackBar(
          context,
          data['message'] ?? 'Registration successful! Please check your email for verification.',
        );
        prefs.setString('email',email) ;
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ?? 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        context,
        'An unexpected error occurred. Please try again later.',
      );
      debugPrint('Registration error: $e');
    }
    return false;
  }

  static String _handleGraphQLException(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      
      final errorCode = firstError.extensions?['status'] as int?;
      switch (errorCode) {
        case 409:
          return 'This email is already registered. Please use a different email or try logging in.';
        case 400:
          return 'Please check your information and try again.';
        case 422:
          return 'Invalid input. Please check your details.';
        default:
          return firstError.message;
      }
    }

    if (exception.linkException != null) {
      return 'Unable to connect to the server. Please check your internet connection.';
    }

    return 'An error occurred. Please try again.';
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    
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
                      'Success',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
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
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    
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
                      'Error',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
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
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  static Future<bool> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(loginMutation),
        variables: {
          'loginInput': {
            'email': email,
            'password': password,
          }
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        _showErrorSnackBar(context, _handleGraphQLException(result.exception!));
        return false;
      }

      final data = result.data?['login'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        await prefs.setString('email', email);
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ?? 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        context,
        'An unexpected error occurred. Please try again later.',
      );
      debugPrint('Login error: $e');
    }
    return false;
  }



  static Future<bool> verifyLogin({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      final client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(verifyLoginMutation),
        variables: {
          'verifyLoginInput': {
            'email': email,
            'otp': otp,
          }
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        _showErrorSnackBar(context, _handleGraphQLException(result.exception!));
        return false;
      }

      final data = result.data?['verifyLogin'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        _showSuccessSnackBar(
          context,
          data['message'] ?? 'Login verified successfully',
        );
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ?? 'Verification failed. Please try again.',
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        context,
        'An unexpected error occurred. Please try again later.',
      );
      debugPrint('Verification error: $e');
    }
    return false;
  }

  static Future<bool> resendOTP({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final client = GraphQLProvider.of(context).value;
      final MutationOptions options = MutationOptions(
        document: gql(resendOtpMutation),
        variables: {
          'email': email,
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        _showErrorSnackBar(context, _handleGraphQLException(result.exception!));
        return false;
      }

      final data = result.data?['resendOTP'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        _showSuccessSnackBar(
          context,
          data['message'] ?? 'OTP has been resent to your email.',
        );
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ?? 'Failed to resend OTP. Please try again.',
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        context,
        'An unexpected error occurred. Please try again later.',
      );
      debugPrint('Resend OTP error: $e');
    }
    return false;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePhone(String? value, String? countryCode) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    if (countryCode == '+250') { // Rwanda
      if (value.length != 9) {
        return 'Rwanda phone numbers must be 9 digits';
      }
      if (!value.startsWith('7')) {
        return 'Rwanda phone numbers must start with 7';
      }
    } else {
      if (value.length < 9) {
        return 'Phone number must be at least 9 digits';
      }
      if (value.length > 10) {
        return 'Phone number cannot exceed 10 digits';
      }
    }
    return null;
  }

  // Token management
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('email');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    return accessToken != null;
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}