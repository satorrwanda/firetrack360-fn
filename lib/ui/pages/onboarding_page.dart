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

class OnboardingPage extends HookConsumerWidget {
  // Changed to ConsumerHookWidget
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Added WidgetRef ref
    // Watch the localeProvider here to trigger rebuilds
    ref.watch(localeProvider);

    final l10n = S.of(context)!;
    final pageController = usePageController();
    final currentPage = useState(0);
    final isMounted = useIsMounted();
    final timerRef = useRef<Timer?>(null);

    // Keep this list for image paths
    final onboardingImages = [
      'assets/images/onboarding1.jpg',
      'assets/images/onboarding2.jpg',
      'assets/images/onboarding3.jpg',
    ];

    // Auto-slide setup
    void startAutoSlide() {
      timerRef.value?.cancel();
      timerRef.value = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!isMounted()) return timer.cancel();
        final next = ((pageController.page ?? 0).toInt() + 1) %
            onboardingImages.length; // Use onboardingImages.length
        pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }

    // Handle onboarding check
    Future<void> checkOnboardingStatus() async {
      if (!isMounted()) return;
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('isOnboardingComplete') ?? false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted()) AppRoutes.navigateToLogin(context);
        });
      }
    }

    // Trigger setup and cleanup
    useEffect(() {
      checkOnboardingStatus();
      startAutoSlide();
      return () {
        timerRef.value?.cancel();
        timerRef.value = null;
      };
    }, []);

    // Handle user navigation
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
          child: Stack(
            children: [
              Column(
                children: [
                  PageIndicator(
                    currentPage: currentPage.value,
                    pageCount:
                        onboardingImages.length, // Use onboardingImages.length
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
                      itemCount: onboardingImages
                          .length, // Use onboardingImages.length
                      onPageChanged: (index) => currentPage.value = index,
                      itemBuilder: (_, index) => OnboardingItem(
                        index: index, // Pass the index
                        screenWidth: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  OnboardingButtons(
                    onRegister: () => handleNavigation(false),
                    onLogin: () => handleNavigation(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
