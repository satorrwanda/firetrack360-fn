import 'dart:async';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_buttons.dart';
import 'package:firetrack360/ui/models/onboarding_content.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_item.dart';
import 'package:firetrack360/ui/pages/auth/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OnboardingPage extends HookWidget {
  OnboardingPage({Key? key}) : super(key: key);

  // Content will be populated from localizations in build method
  late List<OnboardingContent> _onboardingContents;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    // Initialize the content with localized strings
    _onboardingContents = [
      OnboardingContent(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        image:
            'assets/images/onboarding1.jpg', // Make sure asset paths are correct
      ),
      OnboardingContent(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        image:
            'assets/images/onboarding2.jpg', // Make sure asset paths are correct
      ),
      OnboardingContent(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        image:
            'assets/images/onboarding3.jpg', // Make sure asset paths are correct
      ),
    ];

    final pageController = usePageController();
    final currentPage = useState(0);
    final isMounted = useIsMounted();
    final timerRef = useRef<Timer?>(null);

    // Function to check if onboarding has been completed
    Future<void> checkOnboardingStatus() async {
      // Check if the widget is still mounted before performing async operations
      if (!isMounted()) return;

      final prefs = await SharedPreferences.getInstance();
      final isOnboardingComplete =
          prefs.getBool('isOnboardingComplete') ?? false;

      // If onboarding is complete and widget is mounted, navigate to login
      if (isOnboardingComplete) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted()) {
            AppRoutes.navigateToLogin(context);
          }
        });
      }
    }

    // Function to start automatic page sliding
    void startAutoSlide() {
      // Cancel any existing timer
      timerRef.value?.cancel();

      // Start a periodic timer for auto-sliding
      timerRef.value = Timer.periodic(const Duration(seconds: 3), (timer) {
        // Cancel timer if widget is no longer mounted
        if (!isMounted()) {
          timer.cancel();
          return;
        }

        // Animate to the next page if the PageView has clients
        if (pageController.hasClients) {
          final nextPage = ((pageController.page ?? 0).toInt() + 1) %
              _onboardingContents.length;
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    // useEffect hook to perform side effects (checking status and starting auto-slide)
    useEffect(() {
      checkOnboardingStatus();
      startAutoSlide();
      // Cleanup function to cancel the timer when the widget is disposed
      return () {
        timerRef.value?.cancel();
        timerRef.value = null;
      };
    }, []); // Empty dependency array means this effect runs only once on mount

    // Function to handle navigation after completing onboarding
    Future<void> handleNavigation(bool isLogin) async {
      // Check if the widget is still mounted before navigating
      if (!isMounted()) return;

      try {
        debugPrint('Starting navigation process');
        // Cancel the auto-slide timer before navigating
        timerRef.value?.cancel();
        timerRef.value = null;

        // Mark onboarding as complete in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOnboardingComplete', true);

        // Navigate after the current frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted()) {
            if (isLogin) {
              AppRoutes.navigateToLogin(context);
            } else {
              AppRoutes.navigateToRegister(context);
            }
          }
        });
      } catch (e) {
        debugPrint('Navigation error: $e');
        // Consider showing an error message to the user
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
            // Use Stack to layer content and the language toggler
            children: [
              Column(
                // The main content column
                children: [
                  PageIndicator(
                    currentPage: currentPage.value,
                    pageCount: _onboardingContents.length,
                    onPageSelect: (index) {
                      if (!isMounted()) return;
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                      );
                    },
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: _onboardingContents.length,
                      onPageChanged: (page) {
                        if (isMounted()) {
                          currentPage.value = page;
                        }
                      },
                      itemBuilder: (context, index) {
                        return OnboardingItem(
                          content: _onboardingContents[index],
                          screenWidth: MediaQuery.of(context).size.width,
                        );
                      },
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
