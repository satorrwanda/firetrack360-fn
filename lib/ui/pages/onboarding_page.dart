import 'dart:async';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_buttons.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_item.dart';
import 'package:firetrack360/ui/pages/auth/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  // Helper function to launch URL
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localeProvider);

    final l10n = S.of(context)!;
    final pageController = usePageController();
    final currentPage = useState(0);
    final isMounted = useIsMounted();
    final timerRef = useRef<Timer?>(null);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800; // Breakpoint for large screens

    final onboardingImages = [
      'assets/images/onboarding1.jpg',
      'assets/images/onboarding2.jpg',
      'assets/images/onboarding3.jpg',
    ];

    void startAutoSlide() {
      timerRef.value?.cancel();
      timerRef.value = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!isMounted()) return timer.cancel();
        final next =
            ((pageController.page ?? 0).toInt() + 1) % onboardingImages.length;
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }

    Future<void> checkOnboardingStatus() async {
      if (!isMounted()) return;
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isOnboardingComplete') ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted()) AppRoutes.navigateToLogin(context);
        });
      }
    }

    useEffect(() {
      checkOnboardingStatus();
      startAutoSlide();
      return () {
        timerRef.value?.cancel();
        timerRef.value = null;
      };
    }, []);

    Future<void> handleNavigation(bool toLogin) async {
      if (!isMounted()) return;
      try {
        timerRef.value?.cancel();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOnboardingComplete', true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted()) {
            toLogin
                ? AppRoutes.navigateToLogin(context)
                : AppRoutes.navigateToRegister(context);
          }
        });
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    }

    // Widget for large screens - content on left, buttons on right
    Widget buildLargeScreenLayout() {
      return Row(
        children: [
          // Left side: Onboarding content (images and descriptions)
          Expanded(
            flex: 3, // Takes 60% of the width
            child: Column(
              children: [
                PageIndicator(
                  currentPage: currentPage.value,
                  pageCount: onboardingImages.length,
                  onPageSelect: (index) {
                    if (isMounted()) {
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
                    itemCount: onboardingImages.length,
                    onPageChanged: (index) => currentPage.value = index,
                    itemBuilder: (_, index) => OnboardingItem(
                      index: index,
                      screenWidth: screenWidth * 0.6, // 60% of screen width
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right side: Buttons (vertically centered)
          Expanded(
            flex: 2, // Takes 40% of the width
            child: Center(
              child: OnboardingButtons(
                onRegister: () => handleNavigation(false),
                onLogin: () => handleNavigation(true),
                isVertical: true, // Use vertical layout for large screens
              ),
            ),
          ),
        ],
      );
    }

    // Widget for small screens - vertical layout (unchanged)
    Widget buildSmallScreenLayout() {
      return Column(
        children: [
          PageIndicator(
            currentPage: currentPage.value,
            pageCount: onboardingImages.length,
            onPageSelect: (index) {
              if (isMounted()) {
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
              itemCount: onboardingImages.length,
              onPageChanged: (index) => currentPage.value = index,
              itemBuilder: (_, index) => OnboardingItem(
                index: index,
                screenWidth: screenWidth,
              ),
            ),
          ),
          OnboardingButtons(
            onRegister: () => handleNavigation(false),
            onLogin: () => handleNavigation(true),
            isVertical: false, // Use horizontal layout for small screens
          ),
        ],
      );
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
          child: isLargeScreen
              ? buildLargeScreenLayout()
              : buildSmallScreenLayout(),
        ),
      ),
    );
  }
}
