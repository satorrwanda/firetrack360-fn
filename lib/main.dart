import 'package:flutter/material.dart';

void main() {
  runApp(FireExtinguisherShop());
}

class FireExtinguisherShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Extinguisher Shop',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Controller to track the page index
  PageController _pageController = PageController();

  // A function to move to the next page
  void _nextPage() {
    if (_pageController.page == 2) {
      // After the last page, navigate to the main shop page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
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
            imagePath: "assets/onboarding1.png", // Add image in assets
            onNext: _nextPage,
          ),
          OnboardingScreen(
            title: "Wide Range of Products",
            description:
                "Browse through our fire extinguishers and buy them for your safety.",
            imagePath: "assets/onboarding2.png", // Add image in assets
            onNext: _nextPage,
          ),
          OnboardingScreen(
            title: "Refill Services",
            description:
                "We also provide affordable fire extinguisher refill services.",
            imagePath: "assets/onboarding3.png", // Add image in assets
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onNext;

  OnboardingScreen({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250), // Show onboarding image
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: onNext,
            child: Text(
              'Next',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fire Extinguisher Shop")),
      body: Center(
        child: Text("Welcome to the Fire Extinguisher Shop!"),
      ),
    );
  }
}
