import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_buttons.dart';
import 'package:firetrack360/ui/models/onboarding_content.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_item.dart';
import 'package:firetrack360/ui/pages/auth/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: 0);
    final currentPage = useState(0);
    final isAutoSliding = useState(true);
    final screenWidth = MediaQuery.of(context).size.width;

    final onboardingContents = [
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

    // Auto-slide effect
    useEffect(() {
      Timer? timer;

      void startAutoSlide() {
        timer = Timer.periodic(const Duration(seconds: 4), (timer) {
          if (!isAutoSliding.value) return;
          if (!pageController.hasClients) return;

          try {
            if (currentPage.value < onboardingContents.length - 1) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
              );
            } else {
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
              );
            }
          } catch (e) {
            // If there's an error with the page controller, stop auto-sliding
            timer.cancel();
            isAutoSliding.value = false;
          }
        });
      }

      // Delay the start of auto-sliding to ensure the PageController is properly initialized
      Future.delayed(const Duration(milliseconds: 500), startAutoSlide);

      return () {
        timer?.cancel();
        isAutoSliding.value = false;
      };
    }, []);

    void navigateToRegister() {
      AppRoutes.navigateToRegister(context);
    }

    void navigateToLogin() {
      AppRoutes.navigateToLogin(context);
    }

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
                currentPage: currentPage.value,
                pageCount: onboardingContents.length,
                onPageSelect: (index) {
                  if (pageController.hasClients) {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                    );
                  }
                },
              ),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: onboardingContents.length,
                  onPageChanged: (int page) {
                    currentPage.value = page;
                  },
                  itemBuilder: (context, index) {
                    return OnboardingItem(
                      content: onboardingContents[index],
                      screenWidth: screenWidth,
                    );
                  },
                ),
              ),
              OnboardingButtons(
                onRegister: navigateToRegister,
                onLogin: navigateToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
