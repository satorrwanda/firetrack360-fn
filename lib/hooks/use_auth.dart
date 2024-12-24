import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

AuthState useAuth() {
  final state = useState(AuthState(
    isLoading: true,
    isAuthenticated: false,
    userRole: null,
    error: null,
  ));

  useEffect(() {
    Future<void> checkAuthentication() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken');
        final refreshToken = prefs.getString('refreshToken');

        if (accessToken != null && refreshToken != null) {
          final isValid = await _validateToken(accessToken);
          final userRole = _extractUserRole(accessToken);

          state.value = state.value.copyWith(
            isLoading: false,
            isAuthenticated: isValid,
            userRole: userRole,
          );
        } else {
          state.value = state.value.copyWith(
            isLoading: false,
            isAuthenticated: false,
          );
        }
      } catch (e) {
        state.value = state.value.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: e.toString(),
        );
      }
    }

    checkAuthentication();
    return null;
  }, []);

  return state.value;
}

Future<bool> _validateToken(String token) async {
  try {
    return !JwtDecoder.isExpired(token);
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

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userRole;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.userRole,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userRole,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      error: error ?? this.error,
    );
  }
}
