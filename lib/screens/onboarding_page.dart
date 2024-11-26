// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen.dart';
import 'home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  void _nextPage() {
    if (_pageController.page == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          OnboardingScreen(
            title: "Welcome to Fire Extinguisher Shop",
            description:
                "We offer high-quality fire extinguishers and refill services.",
            imagePath:
                "https://firearrest.com/wp-content/uploads/2024/01/Fire-Background.jpg.webp",
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}
