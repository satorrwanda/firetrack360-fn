import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/home/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexSelected;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onIndexSelected,
  });

  static const String users = 'Users';
  static const String service = 'Service';
  static const String inventory = 'Inventory';
  static const String navigation = 'Navigation';
  static const String dashboard = 'Dashboard';
  static const String home = 'Home';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF6741D9),
              Colors.deepPurple.shade800,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 48),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          child: _buildMenuItems(context),
                        ),
                      ),
                    ),
                    LogoutButton(onLogout: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return Dialog(
                            // Use Dialog instead of AlertDialog
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 5, // More pronounced shadow
                            backgroundColor:
                                Theme.of(context).dialogBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  24.0), // More generous padding
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Important for Dialog
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout, // Better icon
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary, // Accent color
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Confirm Logout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Are you sure you want to sign out?', // More user-friendly text
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround, // Even spacing
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.grey[600],
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                          elevation:
                                              3, // Slightly stronger shadow
                                        ),
                                        child: const Text(
                                          'Logout',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      if (shouldLogout != null && shouldLogout) {
                        AuthService.clearAllTokens();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (Route<dynamic> route) => false,
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService.getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        final String? userRole = snapshot.data;
        final bool isAdmin = userRole?.toLowerCase() == 'admin';

        final menuItems = _getAllMenuItems(context, isAdmin);

        return Column(
          children: [
            _buildMenuSection('MENU', [menuItems[0]]),
            const SizedBox(height: 24),
            _buildMenuSection(
              'FEATURES',
              menuItems.skip(1).take(isAdmin ? 4 : 3).toList(),
            ),
            const SizedBox(height: 24),
            _buildMenuSection(
              'OTHER',
              menuItems.skip(isAdmin ? 5 : 4).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuSection(String title, List<DrawerItem> items) {
    // Filter out any null items that might have been added for admin-only features
    final filteredItems = items.where((item) => item != null).toList();

    if (filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...filteredItems,
      ],
    );
  }

  void _handleNavigation(BuildContext context, String title, int index) {
    onIndexSelected(index);
    switch (title) {
      case dashboard:
      case home:
        AppRoutes.navigateToHome(context);
        break;
      case users:
        AppRoutes.navigateToUserManagement(context);
        break;
      case service:
        AppRoutes.navigateToServiceRequests(context);
        break;
      case inventory:
        AppRoutes.navigateToInventory(context);
        break;
      case navigation:
        AppRoutes.navigateToTechnicianNavigation(context);
        break;
      case profile:
        AppRoutes.navigateToProfile(context);
        break;
      case settings:
        AppRoutes.navigateToSettings(context);
        break;
      case notifications:
        AppRoutes.navigateToNotification(context);
        break;
      default:
        AppRoutes.navigateToHome(context);
    }
  }

  List<DrawerItem> _getAllMenuItems(BuildContext context, bool isAdmin) {
    int index = 0;
    final List<DrawerItem> menuItems = [
      // Menu section
      DrawerItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        title: dashboard,
        index: index++,
        isSelected: selectedIndex == 0,
        onTap: () => _handleNavigation(context, dashboard, 0),
      ),
    ];

    // Features section - Add Users only for admin
    if (isAdmin) {
      menuItems.add(_createMenuItem(
          context, Icons.group_outlined, Icons.group, users, index++));
    }

    // Add other feature items that should be visible to all users
    menuItems.addAll([
      _createMenuItem(context, Icons.assignment_outlined, Icons.assignment,
          service, index++),
      _createMenuItem(context, Icons.inventory_2_outlined, Icons.inventory_2,
          inventory, index++),
      _createMenuItem(context, Icons.map_outlined, Icons.map, navigation,
          index++), // Navigation in FEATURES section only
    ]);

    // Other section - Now includes notifications instead of duplicating Navigation
    menuItems.addAll([
      _createMenuItem(
          context, Icons.person_outline, Icons.person, profile, index++),
      _createMenuItem(
          context, Icons.settings_outlined, Icons.settings, settings, index++),
      _createMenuItem(context, Icons.notifications_outlined,
          Icons.notifications, notifications, index++),
    ]);

    return menuItems;
  }

  DrawerItem _createMenuItem(BuildContext context, IconData icon,
          IconData selectedIcon, String title, int index) =>
      DrawerItem(
        icon: icon,
        selectedIcon: selectedIcon,
        title: title,
        index: index,
        isSelected: selectedIndex == index,
        onTap: () => _handleNavigation(context, title, index),
      );
}
