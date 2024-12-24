import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_buttons.dart';
import 'package:firetrack360/ui/models/onboarding_content.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_item.dart';
import 'package:firetrack360/ui/pages/auth/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoSlideTimer;

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
    _checkOnboardingStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAutoSlide();
    });
  }

  void _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;
    if (!isOnboardingComplete) {
      AppRoutes.navigateToLogin(context);
    } else {
      startAutoSlide();
    }
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void startAutoSlide() {
    _autoSlideTimer?.cancel();
    
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        
        if (nextPage < _onboardingContents.length) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _navigateToRegister() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    AppRoutes.navigateToRegister(context);
  }

  void _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
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
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                  );
                },
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingContents.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
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