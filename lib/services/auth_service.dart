import 'package:firetrack360/graphql/mutations/auth_mutations.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> registerUser({
    required BuildContext context,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final client = GraphQLProvider.of(context).value;

      debugPrint('Starting registration for email: $email');

      final MutationOptions options = MutationOptions(
        document: gql(registerMutation),
        variables: {
          'createUserInput': {
            'email': email,
            'phone': phone,
            'password': password,
            'confirmPassword': confirmPassword,
          }
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        debugPrint('GraphQL Errors: ${result.exception?.graphqlErrors}');
        debugPrint('Link Error: ${result.exception?.linkException}');
        final error = _handleGraphQLException(result.exception!);
        _showErrorSnackBar(context, error);
        return false;
      }

      final data = result.data?['register'];
      debugPrint('Received data: $data');

      // Check for HTTP status 201 (CREATED) or message indicating success
      if (data != null && 
          (data['status'] == 201 || // HTTP CREATED status
           data['status'] == 2001 || // Your custom status code if used
           (data['message']?.toString().toLowerCase().contains('success') ?? false))) {
        
        // Store email in SharedPreferences
        await prefs.setString('email', email);
        
        // Show success message
        _showSuccessSnackBar(
          context,
          data['message'] ?? 'Registration successful! Please verify your email with the OTP sent.',
        );
        
       AppRoutes.navigateToActivateAccount(context);
        
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ?? 'Registration failed. Please try again.',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Registration error: $e');
      debugPrint('Stack trace: $stackTrace');
      _showErrorSnackBar(
        context,
        'An unexpected error occurred. Please try again later.',
      );
    }
    return false;
  }

  Future<bool> verifyAccount({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    try {
      final GraphQLClient client = GraphQLProvider.of(context).value;

      final MutationOptions options = MutationOptions(
        document: gql(verifyAccountMutation),
        variables: {
          'email': email,
          'otp': otp,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        return false;
      }

      final dynamic data = result.data?['verifyAccount'];
      return data?['status'] == 200;
    } catch (e) {
      return false;
    }
  }

  String _handleGraphQLException(OperationException exception) {
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

  void _showSuccessSnackBar(BuildContext context, String message) {
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

  void _showErrorSnackBar(BuildContext context, String message) {
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

  Future<bool> loginUser({
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

Future<QueryResult<Object?>> verifyLogin({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      final client = GraphQLProvider.of(context).value;
      debugPrint('Verifying login for email: $email');

      final MutationOptions options = MutationOptions(
        document: gql(verifyLoginMutation),
        variables: {
          'email': email,
          'otp': otp,
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        debugPrint('Verification error: ${result.exception}');
        return result;
      }

      final data = result.data?['verifyLogin'];
      debugPrint('Verification response data: $data');

      if (data != null) {
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;

        if (accessToken != null && refreshToken != null) {
          // Debug print the token before decoding
          debugPrint('Access Token received: $accessToken');
          
          // Decode and print token contents
          final decodedToken = JwtDecoder.decode(accessToken);
          debugPrint('Decoded token contents: $decodedToken');

          // Save tokens - this will extract and save the ID
          await AuthService.saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );

          // Verify the ID was saved
          final savedId = await AuthService.getUserId();
          debugPrint('Verified saved User ID: $savedId');
        }
      }

      return result;
    } catch (e, stackTrace) {
      debugPrint('Verification error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Verification error: $e');
    }
  }

  Future<bool> resendVerificationOtp({
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
        fetchPolicy: FetchPolicy.noCache,
        errorPolicy: ErrorPolicy.all,
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        _showErrorSnackBar(context, _handleGraphQLException(result.exception!));
        return false;
      }

      final data = result.data?['resendVerificationOtp'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        _showSuccessSnackBar(
          context,
          data['message'] ?? 'Verification code has been resent successfully.',
        );
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ??
              'Failed to resend verification code. Please try again.',
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

    if (countryCode == '+250') {
      // Rwanda
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
  static Future<void> clearAllTokens() async {
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

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _userRoleKey = 'userRole';
  static const String _userIdKey = 'userId';

 static Future<void> saveTokens({
  required String accessToken,
  required String refreshToken,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Save tokens
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    // Decode access token for role
    final Map<String, dynamic> decodedAccessToken = JwtDecoder.decode(accessToken);
    debugPrint('Decoded Access Token: $decodedAccessToken');

    // Decode refresh token for user ID
    final Map<String, dynamic> decodedRefreshToken = JwtDecoder.decode(refreshToken);
    debugPrint('Decoded Refresh Token: $decodedRefreshToken');

    // Extract role from access token
    if (decodedAccessToken.containsKey('role')) {
      final role = decodedAccessToken['role'].toString().toLowerCase();
      await prefs.setString(_userRoleKey, role);
      debugPrint('Saved Role: $role');
    }

    // Extract ID from refresh token
    if (decodedRefreshToken.containsKey('id')) {
      final id = decodedRefreshToken['id'].toString();
      await prefs.setString(_userIdKey, id);
      debugPrint('Saved ID from refresh token: $id');
    } else {
      debugPrint('No ID found in refresh token');
    }

    // Verify saved data
    final savedId = await prefs.getString(_userIdKey);
    final savedRole = await prefs.getString(_userRoleKey);
    debugPrint('Verification - Saved ID: $savedId, Saved Role: $savedRole');

  } catch (e, stackTrace) {
    debugPrint('Error saving tokens: $e');
    debugPrint('Stack trace: $stackTrace');
    throw Exception('Failed to save authentication data');
  }
}
  static Future<Map<String, dynamic>?> getDecodedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      if (token == null) return null;
      return JwtDecoder.decode(token);
    } catch (e) {
      debugPrint('Error decoding token: $e');
      return null;
    }
  }

  static Future<String?> getRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (e) {
      debugPrint('Error getting role: $e');
      return null;
    }
  }

  static Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      if (token == null) return false;
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      debugPrint('Error checking authentication: $e');
      return false;
    }
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userRoleKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

}
