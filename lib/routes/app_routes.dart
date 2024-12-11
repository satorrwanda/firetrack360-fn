import 'package:firetrack360/ui/screens/account_activation_page.dart';
import 'package:firetrack360/ui/screens/forget_password_page.dart';
import 'package:firetrack360/ui/screens/login_page.dart';
import 'package:firetrack360/ui/screens/onboarding_page.dart';
import 'package:firetrack360/ui/screens/register_page.dart';
import 'package:firetrack360/ui/screens/unknown_route_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoutes {
  const AppRoutes._();

  static const String onboarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forget-password';
  static const String activateAccount = '/activate-account';

  static const String _onboardingKey = 'isOnboardingDone';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      onboarding: (_) => const OnboardingPage(),
      login: (_) => const LoginPage(),
      register: (_) => const RegisterPage(),
      forgetPassword: (_) => const ForgetPasswordPage(),
      activateAccount: (_) => const AccountActivationPage(),
    };
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const UnknownRoutePage(),
      settings: settings,
    );
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(login);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(register);
  }

  static void navigateToForgetPassword(BuildContext context) {
    Navigator.of(context).pushNamed(forgetPassword);
  }

  static void navigateToActivateAccount(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(activateAccount);
  }

  static void navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(onboarding);
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> checkInitialRoute(BuildContext context) async {
    try {
      final isComplete = await isOnboardingComplete();
      if (isComplete) {
        navigateToLogin(context);
      } else {
        navigateToOnboarding(context);
      }
    } catch (e) {
      debugPrint('Error checking initial route: $e');
      navigateToOnboarding(context);
    }
  }

  static void resetAndNavigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
    );
  }

  static void popUntilRoute(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }
}