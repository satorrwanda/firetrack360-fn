import 'package:firetrack360/ui/screens/account_activation_page.dart';
import 'package:firetrack360/ui/screens/forget_password_page.dart';
import 'package:firetrack360/ui/screens/login_page.dart';
import 'package:firetrack360/ui/screens/onboarding_page.dart';
import 'package:firetrack360/ui/screens/register_page.dart';
import 'package:firetrack360/ui/screens/unknown_route_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String activateAccount = '/activate-account';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      onboarding: (context) => const OnboardingPage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      forgetPassword: (context) => const ForgetPasswordPage(),
      activateAccount:((Context) => const AccountActivationPage())
    };
  }
  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const UnknownRoutePage());
  }

  static void navigateToNextPage(BuildContext context, bool isOnboardingDone) {
    if (isOnboardingDone) {
      Navigator.of(context).pushReplacementNamed(login);
    } else {
      Navigator.of(context).pushReplacementNamed(onboarding);
    }
  }

  static Future<void> checkInitialRoute(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingDone = prefs.getBool('isOnboardingDone') ?? false;

    navigateToNextPage(context, isOnboardingDone);
  }
}