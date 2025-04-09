import 'dart:async';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AuthGateway extends HookWidget {
  final Widget child;

  const AuthGateway({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authState = useAuth();

    useEffect(() {
      Future<void> handleLogout() async {
        if (!context.mounted) return;

        try {
          // await AuthService.logout();

          if (!context.mounted) return;

          if (authState.isTokenExpired) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your session has expired. Please log in again.'),
                duration: Duration(seconds: 3),
              ),
            );
          }

          Navigator.pushReplacementNamed(
            context,
            AppRoutes.login,
          );
        } catch (e) {
          debugPrint('Error during logout: $e');
        }
      }

      if (!authState.isLoading &&
          (!authState.isAuthenticated || authState.isTokenExpired)) {
        scheduleMicrotask(handleLogout);
      }

      return () {};
    }, [authState.isAuthenticated, authState.isTokenExpired]);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return child;
  }
}
