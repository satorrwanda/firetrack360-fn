import 'package:flutter/material.dart';
import 'screens/onboarding_page.dart';

void main() {
  runApp(const FireExtinguisherShop());
}

class FireExtinguisherShop extends StatelessWidget {
  const FireExtinguisherShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Extinguisher Shop',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OnboardingPage(),
    );
  }
}
