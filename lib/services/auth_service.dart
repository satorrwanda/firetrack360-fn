import 'package:firetrack360/graphql/mutations/auth_mutations.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import l10n

class AuthService {
  Future<bool> registerUser({
    required BuildContext context,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final l10n = S.of(context)!; // Access l10n here

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
        final error =
            _handleGraphQLException(context, result.exception!); // Pass context
        _showErrorSnackBar(context, error);
        return false;
      }

      final data = result.data?['register'];
      debugPrint('Received data: $data');

      // Check for HTTP status 201 (CREATED) or message indicating success
      if (data != null &&
          (data['status'] == 201 || // HTTP CREATED status
              data['status'] == 2001 || // Your custom status code if used
              (data['message']?.toString().toLowerCase().contains('success') ??
                  false))) {
        // Store email in SharedPreferences
        await prefs.setString('email', email);

        // Show success message
        _showSuccessSnackBar(
          context,
          data['message'] ??
              l10n.registrationSuccessDefaultMessage, // Use localized fallback
        );

        AppRoutes.navigateToActivateAccount(context);

        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ??
              l10n.registrationFailedDefaultMessage, // Use localized fallback
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Registration error: $e');
      debugPrint('Stack trace: $stackTrace');
      _showErrorSnackBar(
        context,
        l10n.unexpectedAuthError, // Use localized message
      );
    }
    return false;
  }

  Future<bool> verifyAccount({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    // Localization in this method is not directly needed for text display,
    // as it primarily handles logic.
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
        // Consider showing a localized error here as well if verification fails
        return false;
      }

      final dynamic data = result.data?['verifyAccount'];
      return data?['status'] == 200;
    } catch (e) {
      // Consider showing a localized error here as well
      return false;
    }
  }

  String _handleGraphQLException(
      BuildContext context, OperationException exception) {
    // Added BuildContext
    final l10n = S.of(context)!; // Access l10n here

    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;

      final errorCode = firstError.extensions?['status'] as int?;
      switch (errorCode) {
        case 409:
          return l10n.emailAlreadyRegisteredError; // Use localized message
        case 400:
          return l10n.checkInformationError; // Use localized message
        case 422:
          return l10n.invalidInputError; // Use localized message
        default:
          // If the server provides a specific message, use it.
          // Otherwise, fall back to a localized default error.
          return firstError.message.isNotEmpty
              ? firstError.message
              : l10n.defaultError;
      }
    }

    if (exception.linkException != null) {
      return l10n.connectionError; // Use localized message
    }

    return l10n.defaultError; // Use localized message
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    final l10n = S.of(context)!; // Access l10n here

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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message, // This message is already localized
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
          label: l10n.dismissSnackBarAction, // Use localized action label
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
    final l10n = S.of(context)!; // Access l10n here

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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message, // This message is already localized
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
          label: l10n.dismissSnackBarAction, // Use localized action label
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
    final l10n = S.of(context)!; // Access l10n here

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
        _showErrorSnackBar(
            context,
            _handleGraphQLException(
                context, result.exception!)); // Pass context
        return false;
      }

      final data = result.data?['login'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        await prefs.setString('email', email);
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ??
              l10n.loginFailedDefaultMessage, // Use localized fallback
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        context,
        l10n.unexpectedAuthError, // Use localized message
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
    // You could access l10n here if you need to show snackbars
    // in this method directly based on the result.
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
        // Consider showing a localized error here as well if verification fails
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

          // Decode refresh token for user ID
          final Map<String, dynamic> decodedRefreshToken =
              JwtDecoder.decode(refreshToken);
          debugPrint('Decoded Refresh Token: $decodedRefreshToken');

          // Save tokens - this will extract and save the ID and role
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
      // Consider showing a localized error here as well
      throw Exception('Verification error: $e');
    }
  }

  Future<bool> resendVerificationOtp({
    required BuildContext context,
    required String email,
  }) async {
    final l10n = S.of(context)!; // Access l10n here

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
        _showErrorSnackBar(
            context,
            _handleGraphQLException(
                context, result.exception!)); // Pass context
        return false;
      }

      final data = result.data?['resendVerificationOtp'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        _showSuccessSnackBar(
          context,
          data['message'] ??
              l10n.resendOtpSuccessDefaultMessage, // Use localized fallback
        );
        return true;
      } else {
        _showErrorSnackBar(
          context,
          data?['message'] ??
              l10n.resendOtpFailedDefaultMessage, // Use localized fallback
        );
      }
    } catch (e) {
      _showErrorSnackBar(
        context,
        l10n.unexpectedAuthError, // Use localized message
      );
      debugPrint('Resend OTP error: $e');
    }
    return false;
  }

  // --- Static Validation Methods (These are separate from the service instance methods) ---

  // These static validator methods need to be called from a widget's
  // validator property using a lambda to access BuildContext.

  static String? validateEmail(BuildContext context, String? value) {
    // Added BuildContext
    final l10n = S.of(context)!; // Access l10n here

    if (value == null || value.isEmpty) {
      return l10n.enterEmailError; // Use localized message
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
    );

    if (!emailRegex.hasMatch(value)) {
      return l10n.invalidEmailError; // Use localized message
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    // Added BuildContext
    final l10n = S.of(context)!; // Access l10n here

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

  static String? validateConfirmPassword(
      BuildContext context, String? value, String password) {
    // Added BuildContext
    final l10n = S.of(context)!; // Access l10n here

    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordError; // Use localized message
    }
    if (value != password) {
      return l10n.passwordsDoNotMatchError; // Use localized message
    }
    return null;
  }

  static String? validatePhone(
      BuildContext context, String? value, String? countryCode) {
    // Added BuildContext
    final l10n = S.of(context)!; // Access l10n here

    if (value == null || value.isEmpty) {
      return l10n.enterPhoneNumberError; // Use localized message
    }

    if (countryCode == '+250') {
      // Rwanda
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
        // This validation seems off, max length 10 is less than 9 digits.
        // Consider if this is intended or a typo. Assuming it's intended based on original code.
        return l10n.phoneNumberMaxLengthError; // Use localized message
      }
    }
    return null;
  }

  // Token management methods (localization not directly needed here)
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

  static Future<void> logout() async {
    await clearAllTokens();
    debugPrint(
        'Logged out successfully'); // Consider localizing this if shown to user
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
      final Map<String, dynamic> decodedAccessToken =
          JwtDecoder.decode(accessToken);
      debugPrint('Decoded Access Token: $decodedAccessToken');

      // Decode refresh token for user ID
      final Map<String, dynamic> decodedRefreshToken =
          JwtDecoder.decode(refreshToken);
      debugPrint('Decoded Refresh Token: $decodedRefreshToken');

      // Extract role from access token
      if (decodedAccessToken.containsKey('role')) {
        final role = decodedAccessToken['role'].toString().toLowerCase();
        await prefs.setString(_userRoleKey, role);
        debugPrint('Saved Role: $role'); // Consider localizing
      }

      // Extract ID from refresh token
      if (decodedRefreshToken.containsKey('id')) {
        final id = decodedRefreshToken['id'].toString();
        await prefs.setString(_userIdKey, id);
        debugPrint('Saved ID from refresh token: $id'); // Consider localizing
      } else {
        debugPrint('No ID found in refresh token'); // Consider localizing
      }

      // Verify saved data
      final savedId = await prefs.getString(_userIdKey);
      final savedRole = await prefs.getString(_userRoleKey);
      debugPrint(
          'Verification - Saved ID: $savedId, Saved Role: $savedRole'); // Consider localizing
    } catch (e, stackTrace) {
      debugPrint(
          'Error saving tokens: $e'); // Consider localizing if shown to user
      debugPrint(
          'Stack trace: $stackTrace'); // Consider localizing if shown to user
      throw Exception(
          'Failed to save authentication data'); // Consider localizing
    }
  }

  static Future<Map<String, dynamic>?> getDecodedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_accessTokenKey);
      if (token == null) return null;
      return JwtDecoder.decode(token);
    } catch (e) {
      debugPrint('Error decoding token: $e'); // Consider localizing if shown
      return null;
    }
  }

  static Future<String?> getRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userRoleKey);
    } catch (e) {
      debugPrint('Error getting role: $e'); // Consider localizing if shown
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
      debugPrint(
          'Error checking authentication: $e'); // Consider localizing if shown
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
