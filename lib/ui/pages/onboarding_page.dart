import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_buttons.dart';
import 'package:firetrack360/ui/models/onboarding_content.dart';
import 'package:firetrack360/ui/pages/auth/widgets/onboarding_item.dart';
import 'package:firetrack360/ui/pages/auth/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends HookWidget {
  OnboardingPage({Key? key}) : super(key: key);

  // Content will be populated from localizations in build method
  late List<OnboardingContent> _onboardingContents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Initialize the content with localized strings
    _onboardingContents = [
      OnboardingContent(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        image: 'assets/images/onboarding1.jpg',
      ),
      OnboardingContent(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        image: 'assets/images/onboarding2.jpg',
      ),
      OnboardingContent(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        image: 'assets/images/onboarding3.jpg',
      ),
    ];

    final pageController = usePageController();
    final currentPage = useState(0);
    final isMounted = useIsMounted();
    final timerRef = useRef<Timer?>(null);

    Future<void> checkOnboardingStatus() async {
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingComplete =
          prefs.getBool('isOnboardingComplete') ?? false;

      if (isOnboardingComplete && isMounted()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted()) {
            AppRoutes.navigateToLogin(context);
          }
        });
      }
    }

    void startAutoSlide() {
      timerRef.value?.cancel();

      timerRef.value = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!isMounted()) {
          timer.cancel();
          return;
        }

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

    useEffect(() {
      checkOnboardingStatus();
      startAutoSlide();
      return () {
        timerRef.value?.cancel();
        timerRef.value = null;
      };
    }, []);

    Future<void> handleNavigation(bool isLogin) async {
      if (!isMounted()) return;

      try {
        debugPrint('Starting navigation process');
        timerRef.value?.cancel();
        timerRef.value = null;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOnboardingComplete', true);

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
          child: Column(
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
        ),
      ),
    );
  }
}
