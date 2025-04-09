import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userRole;
  final String? error;
  final bool isTokenExpired;
  final String? userId;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.userRole,
    this.error,
    this.isTokenExpired = false,
    this.userId,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userRole,
    String? error,
    bool? isTokenExpired,
    String? userId,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      error: error ?? this.error,
      isTokenExpired: isTokenExpired ?? this.isTokenExpired,
      userId: userId ?? this.userId,
    );
  }
}

AuthState useAuth() {
  final state = useState(AuthState(
    isLoading: true,
    isAuthenticated: false,
    userRole: null,
    error: null,
    isTokenExpired: false,
    userId: null,
  ));

  Future<void> checkAuthentication() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final refreshToken = prefs.getString('refreshToken');

      if (accessToken != null && refreshToken != null) {
        final isValid = await _validateToken(accessToken);
        final userRole = _extractUserRole(accessToken);
        final userId = _extractUserId(accessToken);

        state.value = state.value.copyWith(
          isLoading: false,
          isAuthenticated: isValid,
          userRole: userRole,
          userId: userId,
          isTokenExpired: !isValid,
        );
      } else {
        state.value = state.value.copyWith(
          isLoading: false,
          isAuthenticated: false,
          isTokenExpired: true,
        );
      }
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: e.toString(),
        isTokenExpired: true,
      );
    }
  }

  useEffect(() {
    checkAuthentication();

    if (state.value.isAuthenticated) {
      final timer = Timer.periodic(
        const Duration(minutes: 5),
        (_) => checkAuthentication(),
      );
      return () => timer.cancel();
    }

    return null;
  }, [state.value.isAuthenticated]);

  return state.value;
}

Future<bool> _validateToken(String token) async {
  try {
    final decodedToken = JwtDecoder.decode(token);
    if (!decodedToken.containsKey('exp')) return false;

    final expirationDate = DateTime.fromMillisecondsSinceEpoch(
      decodedToken['exp'] * 1000,
    );
    return DateTime.now().isBefore(
      expirationDate.subtract(const Duration(minutes: 5)),
    );
  } catch (e) {
    return false;
  }
}

String? _extractUserRole(String token) {
  try {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['role'] as String?;
  } catch (e) {
    return null;
  }
}

String? _extractUserId(String token) {
  try {
    final decodedToken = JwtDecoder.decode(token);
    return decodedToken['userId'] as String?;
  } catch (e) {
    return null;
  }
}
