import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/routes/app_routes.dart';

class CustomBottomNav extends HookWidget {
  final String? userRole;
  // Add static variable to persist selected label across instances
  static String currentLabel = 'Home';

  const CustomBottomNav({
    super.key,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize state with the static value
    final selectedLabel = useState(CustomBottomNav.currentLabel);
    final navigatorState = Navigator.of(context);

    void handleNavigation(String label) {
      selectedLabel.value = label;
      // Update static value
      CustomBottomNav.currentLabel = label;

      switch (label) {
        case 'Home':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
            navigatorState.pushReplacementNamed(AppRoutes.home);
          }
          break;
        case 'Analytics':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.analytics) {
            navigatorState.pushNamed(AppRoutes.analytics);
          }
          break;
        case 'Profile':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
            navigatorState.pushNamed(AppRoutes.profile);
          }
          break;
      }
    }

    // Ensure we're using the Material widget for proper theming
    return Material(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex:
                ['Home', 'Analytics', 'Profile'].indexOf(selectedLabel.value),
            onTap: (index) =>
                handleNavigation(['Home', 'Analytics', 'Profile'][index]),
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(Icons.analytics),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
