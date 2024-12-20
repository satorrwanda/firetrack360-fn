import 'package:firetrack360/ib/hooks/use_auth.dart';
import 'package:firetrack360/ib/hooks/use_navigation.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/custom_bottom_nav.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = useAuth();
    final selectedIndex = useState(0);
    final bottomNavIndex = useState(0);
    final navigator = useNavigation();
    print(authState.userRole);
    // Redirect if not authenticated
    useEffect(() {
      if (!authState.isLoading && !authState.isAuthenticated) {
        Future.microtask(() {
          navigator.navigateAndRemoveUntil(AppRoutes.login);
        });
      }
      return null;
    }, [authState.isAuthenticated]);

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
          navigator.navigateTo(AppRoutes.settings);
          break;
      }
    }

    Future<void> handleLogout() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
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

      if (confirmed == true) {
        await AuthService.clearTokens();
        if (context.mounted) {
          navigator.navigateAndRemoveUntil(AppRoutes.login);
        }
      }
    }

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('FireTrack360'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        selectedIndex: selectedIndex.value,
        onIndexSelected: (index) => selectedIndex.value = index,
        onLogout: handleLogout,
        userRole: authState.userRole,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page Content'),
            const SizedBox(height: 16),
            if (authState.userRole != null)
              Text('Current Role: ${authState.userRole}'),
            if (authState.error != null)
              Text(
                'Error: ${authState.error}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: bottomNavIndex.value,
        onIndexSelected: handleBottomNavTap,
      ),
    );
  }
}
