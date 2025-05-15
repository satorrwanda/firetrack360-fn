import 'package:firetrack360/generated/l10n.dart'; // Import l10n
import 'package:flutter/material.dart';

class OnboardingItem extends StatefulWidget {
  final int index; // Accept the index
  final double screenWidth;

  const OnboardingItem({
    super.key,
    required this.index, // Require the index
    required this.screenWidth,
  });

  @override
  _OnboardingItemState createState() => _OnboardingItemState();
}

class _OnboardingItemState extends State<OnboardingItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Animation duration
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn, // Fade in smoothly
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Start slightly below
      end: Offset.zero, // Slide to original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // A more dynamic slide curve
    ));

    // Start the animation when the widget is created
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n here

    // Determine content based on index
    String title;
    String description;
    String image;

    switch (widget.index) {
      // Use widget.index
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

    // Adjust padding and font sizes based on screen width
    final double horizontalPadding = widget.screenWidth < 600 ? 16 : 24;
    final double verticalPadding = widget.screenWidth < 600 ? 16 : 32;
    final double titleFontSize = widget.screenWidth < 600 ? 24 : 32;
    final double descriptionFontSize = widget.screenWidth < 600 ? 14 : 16;
    final double imageMarginHorizontal = widget.screenWidth < 600 ? 16 : 32;
    final double spacing = widget.screenWidth < 600 ? 16 : 24;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: widget.screenWidth *
                      0.9, // Make the image container responsive
                  margin:
                      EdgeInsets.symmetric(horizontal: imageMarginHorizontal),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple
                            .withOpacity(0.4), // Increased opacity
                        blurRadius: 25, // Increased blur
                        offset: const Offset(0, 15), // Adjusted offset
                        spreadRadius: 3, // Increased spread
                      ),
                    ],
                    borderRadius:
                        BorderRadius.circular(30), // Slightly larger radius
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(30), // Match container radius
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (image
                            .isNotEmpty) // Add a check for empty image path
                          Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade900
                                    .withOpacity(0.8), // Stronger gradient
                                Colors.deepPurple.shade700.withOpacity(0.4),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [
                                0.0,
                                0.5,
                                1.0
                              ], // Define gradient stops
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing),
              Text(
                title, // Use the local 'title' variable
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.3, // Slightly increased spacing
                  shadows: [
                    Shadow(
                      blurRadius: 12.0, // Increased blur
                      color: Colors.black.withOpacity(0.4), // Increased opacity
                      offset: const Offset(2, 3), // Adjusted offset
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: spacing * 0.8), // Slightly less space after title
              Text(
                description, // Use the local 'description' variable
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: descriptionFontSize,
                  color: Colors.white.withOpacity(0.95), // Slightly more opaque
                  letterSpacing: 0.9, // Slightly increased spacing
                  height: 1.5, // Increased line height
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
