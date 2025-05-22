import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/home/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'drawer_item.dart';
import 'package:firetrack360/generated/l10n.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexSelected;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onIndexSelected,
  });
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

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
                          child: _buildMenuItems(context, l10n), // Pass l10n
                        ),
                      ),
                    ),
                    LogoutButton(onLogout: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          final dialogL10n =
                              S.of(context)!; 
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 5,
                            backgroundColor:
                                Theme.of(context).dialogBackgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 48,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    dialogL10n.confirmLogoutTitle,
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
                                    dialogL10n.confirmLogoutMessage,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.grey[600],
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                        ),
                                        child: Text(dialogL10n
                                            .cancelButton), // Localized button text
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
                                          elevation: 3,
                                        ),
                                        child: Text(
                                          dialogL10n
                                              .logoutButton, // Localized button text
                                          style: const TextStyle(
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

  Widget _buildMenuItems(BuildContext context, S l10n) {
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

        // Get localized menu items
        final menuItems = _getAllMenuItems(context, isAdmin, l10n);

        return Column(
          children: [
            _buildMenuSection(l10n.drawerMenuTitle, [menuItems[0]]),
            const SizedBox(height: 24),
            _buildMenuSection(
              l10n.drawerFeaturesTitle, // Localized section title
              menuItems.skip(1).take(isAdmin ? 4 : 3).toList(),
            ),
            const SizedBox(height: 24),
            _buildMenuSection(
              l10n.drawerOtherTitle, // Localized section title
              menuItems.skip(isAdmin ? 5 : 4).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuSection(String title, List<DrawerItem> items) {
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
            title, // Use the localized section title
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

  void _handleNavigation(
      BuildContext context, String title, int index, S l10n) {
    onIndexSelected(index);
    if (title == l10n.drawerItemDashboard || title == l10n.drawerItemHome) {
      AppRoutes.navigateToHome(context);
    } else if (title == l10n.drawerItemUsers) {
      AppRoutes.navigateToUserManagement(context);
    } else if (title == l10n.drawerItemService) {
      AppRoutes.navigateToServiceRequests(context);
    } else if (title == l10n.drawerItemInventory) {
      AppRoutes.navigateToInventory(context);
    } else if (title == l10n.drawerItemNavigation) {
      AppRoutes.navigateToTechnicianNavigation(context);
    } else if (title == l10n.drawerItemProfile) {
      AppRoutes.navigateToProfile(context);
    } else if (title == l10n.drawerItemSettings) {
      AppRoutes.navigateToSettings(context);
    } else if (title == l10n.drawerItemNotifications) {
      AppRoutes.navigateToNotification(context);
    } else {
      AppRoutes.navigateToHome(context); // Default navigation
    }
  }

  List<DrawerItem> _getAllMenuItems(
      BuildContext context, bool isAdmin, S l10n) {
    int index = 0;
    final List<DrawerItem> menuItems = [
      // Menu section
      _createMenuItem(
          context,
          Icons.dashboard_outlined,
          Icons.dashboard,
          l10n.drawerItemDashboard, // Localized title
          index++,
          l10n), // Pass l10n
    ];

    // Features section - Add Users only for admin
    if (isAdmin) {
      menuItems.add(_createMenuItem(
          context,
          Icons.group_outlined,
          Icons.group,
          l10n.drawerItemUsers, // Localized title
          index++,
          l10n)); // Pass l10n
    }

    // Add other feature items that should be visible to all users
    menuItems.addAll([
      _createMenuItem(
          context,
          Icons.assignment_outlined,
          Icons.assignment,
          l10n.drawerItemService, // Localized title
          index++,
          l10n), // Pass l10n
      _createMenuItem(
          context,
          Icons.inventory_2_outlined,
          Icons.inventory_2,
          l10n.drawerItemInventory, // Localized title
          index++,
          l10n), // Pass l10n
      _createMenuItem(
          context,
          Icons.map_outlined,
          Icons.map,
          l10n.drawerItemNavigation, // Localized title
          index++,
          l10n), // Pass l10n
    ]);

    // Other section - Now includes notifications
    menuItems.addAll([
      _createMenuItem(
          context,
          Icons.person_outline,
          Icons.person,
          l10n.drawerItemProfile, // Localized title
          index++,
          l10n), // Pass l10n
      _createMenuItem(
          context,
          Icons.settings_outlined,
          Icons.settings,
          l10n.drawerItemSettings, // Localized title
          index++,
          l10n), // Pass l10n
      _createMenuItem(
          context,
          Icons.notifications_outlined,
          Icons.notifications,
          l10n.drawerItemNotifications, // Localized title
          index++,
          l10n), // Pass l10n
    ]);

    return menuItems;
  }

  // Modified _createMenuItem to accept l10n
  DrawerItem _createMenuItem(BuildContext context, IconData icon,
          IconData selectedIcon, String title, int index, S l10n) =>
      DrawerItem(
        icon: icon,
        selectedIcon: selectedIcon,
        title: title, // This title is already localized when passed in
        index: index,
        isSelected: selectedIndex == index,
        onTap: () =>
            _handleNavigation(context, title, index, l10n), // Pass l10n
      );
}
