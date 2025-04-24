import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/routes/app_routes.dart';

class CustomBottomNav extends HookWidget {
  final String? userRole;
  static String currentLabel = 'Home';

  const CustomBottomNav({
    super.key,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // Validate currentLabel
    String initialLabel = CustomBottomNav.currentLabel;
    if (!['Home', 'Profile'].contains(initialLabel)) {
      initialLabel = 'Home';
      CustomBottomNav.currentLabel = 'Home';
    }

    final selectedLabel = useState(initialLabel);
    final navigatorState = Navigator.of(context);

    void handleNavigation(String label) {
      selectedLabel.value = label;
      CustomBottomNav.currentLabel = label;

      switch (label) {
        case 'Home':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
            navigatorState.pushReplacementNamed(AppRoutes.home);
          }
          break;
        case 'Profile':
          if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
            navigatorState.pushReplacementNamed(AppRoutes.profile);
          }
          break;
      }
    }

    final items = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    final currentIndex = ['Home', 'Profile'].indexOf(selectedLabel.value);

    return Material(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
            currentIndex: currentIndex,
            onTap: (index) => handleNavigation(['Home', 'Profile'][index]),
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey.shade600,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: items,
          ),
        ),
      ),
    );
  }
}
