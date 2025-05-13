import 'package:firetrack360/generated/l10n.dart'; // Import l10n
import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  final int index; // Accept the index
  final double screenWidth;

  const OnboardingItem({
    super.key,
    required this.index, // Require the index
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n here

    // Determine content based on index
    String title;
    String description;
    String image;

    switch (index) {
      case 0:
        title = l10n.onboardingTitle1;
        description = l10n.onboardingDesc1;
        image = 'assets/images/onboarding1.jpg';
        break;
      case 1:
        title = l10n.onboardingTitle2;
        description = l10n.onboardingDesc2;
        image = 'assets/images/onboarding2.jpg';
        break;
      case 2:
        title = l10n.onboardingTitle3;
        description = l10n.onboardingDesc3;
        image = 'assets/images/onboarding3.jpg';
        break;
      default:
        // Handle unexpected index, maybe show an error or default content
        title = 'Error';
        description = 'Something went wrong.';
        image = ''; // Provide a default or placeholder image
        break;
    }

    return Padding(
      padding: EdgeInsets.all(screenWidth < 600 ? 16 : 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (image.isNotEmpty) // Add a check for empty image path
                      Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.deepPurple.shade900.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title, // Use the local 'title' variable
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth < 600 ? 28 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description, // Use the local 'description' variable
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth < 600 ? 16 : 18,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.8,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
