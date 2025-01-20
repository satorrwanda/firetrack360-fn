import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/hooks/use_navigation.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/routes/auth_gateway.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/custom_bottom_nav.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hooks
    final authState = useAuth();
    final selectedIndex = useState(0);
    final bottomNavIndex = useState(0);
    final navigator = useNavigation();

    // Navigation Handlers
    void handleBottomNavTap(int index) {
      bottomNavIndex.value = index;
      
      switch (index) {
        case 0:
          navigator.navigateAndReplace(AppRoutes.home);
          break;
        case 1:
          navigator.navigateTo(AppRoutes.analytics);
          break;
        case 2:
          navigator.navigateTo(AppRoutes.profile);
          break;
      }
    }

    // Authentication Handlers
    Future<void> handleLogout() async {
      final confirmed = await _showLogoutConfirmationDialog(context);

      if (confirmed == true) {
        await AuthService.clearTokens();
        if (context.mounted) {
          navigator.navigateAndRemoveUntil(AppRoutes.login);
        }
      }
    }

    return AuthGateway(
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: CustomDrawer(
          selectedIndex: selectedIndex.value,
          onIndexSelected: (index) => selectedIndex.value = index,
          onLogout: handleLogout,
        ),
        body: _buildBody(authState),
        bottomNavigationBar: CustomBottomNav(
          selectedIndex: bottomNavIndex.value,
          onIndexSelected: handleBottomNavTap,
        ),
      ),
    );
  }

  // UI Components
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'FireTrack360',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    );
  }

  Widget _buildBody(AuthState authState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home Page Content',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (authState.userRole != null)
              Text(
                'Current Role: ${authState.userRole}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            if (authState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Error: ${authState.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Dialogs
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}