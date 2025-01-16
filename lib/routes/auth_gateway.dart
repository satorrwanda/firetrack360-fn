import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/routes/app_routes.dart';
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
      if (!authState.isLoading && !authState.isAuthenticated) {
        Future.microtask(() {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            (route) => false,
          );
        });
      }
      return null;
    }, [authState.isAuthenticated]);

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