
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/screens/forget_password_page.dart';
import 'ui/screens/onboarding_page.dart';
import 'ui/screens/login_page.dart';
import 'ui/screens/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the onboarding is complete
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
  

  runApp(FireExtinguisherShop(
    initialRoute: onboardingComplete ? '/onboarding': "/login" ,
  ));
}

class FireExtinguisherShop extends StatelessWidget {
  final String initialRoute;

  const FireExtinguisherShop({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Extinguisher Shop',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forget-password': (context) => const ForgetPasswordPage()
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }
}
