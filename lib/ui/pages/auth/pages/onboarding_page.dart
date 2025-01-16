import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_buttons.dart';
import 'package:firetrack360/ui/models/onboarding_content.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_item.dart';
import 'package:firetrack360/ui/pages/auth/widgets/page_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<OnboardingContent> _onboardingContents = [
    OnboardingContent(
      title: 'Welcome to FireSecure360',
      description: 'Secure your world, one tap at a time',
      image: 'assets/images/onboarding1.jpg',
    ),
    OnboardingContent(
      title: 'Get Started',
      description: 'Create an account or log in to access all features',
      image: 'assets/images/onboarding2.jpg',
    ),
    OnboardingContent(
      title: 'Secure and Simple',
      description: 'Streamline your security management',
      image: 'assets/images/onboarding3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _stopAutoSlide() {
    _timer?.cancel();
    _timer = null;
  }

  void _startAutoSlide() {
    _stopAutoSlide(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      
      if (_currentPage < _onboardingContents.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _navigateToRegister() {
    _stopAutoSlide(); // Stop auto-slide before navigation
    AppRoutes.navigateToRegister(context);
  }

  void _navigateToLogin() {
    _stopAutoSlide(); // Stop auto-slide before navigation
    AppRoutes.navigateToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade400,
              Colors.deepPurple.shade800,
            ],
            stops: const [0.3, 0.9],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              PageIndicator(
                currentPage: _currentPage,
                pageCount: _onboardingContents.length,
                onPageSelect: (index) {
                  if (_pageController.hasClients) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                    );
                  }
                },
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingContents.length,
                  onPageChanged: (int page) {
                    if (mounted) {
                      setState(() {
                        _currentPage = page;
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    return OnboardingItem(
                      content: _onboardingContents[index],
                      screenWidth: screenWidth,
                    );
                  },
                ),
              ),
              OnboardingButtons(
                onRegister: _navigateToRegister,
                onLogin: _navigateToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}