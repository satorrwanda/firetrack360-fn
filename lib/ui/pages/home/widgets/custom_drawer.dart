import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/home/widgets/custom_drawer_header.dart';
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

  static const String analytics = 'Analytics';
  static const String customers = 'Customers';
  static const String service = 'Service';
  static const String inventory = 'Inventory';
  static const String finance = 'Finance';
  static const String aiInsights = 'AI Insights';
  static const String staff = 'Staff';
  static const String technician = 'Technician';
  static const String task = 'Task';
  static const String location = 'Location';
  static const String stock = 'Stock';
  static const String tasks = 'Tasks';
  static const String navigation = 'Navigation';
  static const String offlineMode = 'Offline Mode';
  static const String customerFeedback = 'Customer Feedback';
  static const String dashboard = 'Dashboard';
  static const String extinguishers = 'Extinguishers';
  static const String requestService = 'Request Service';
  static const String payments = 'Payments & Billing';
  static const String support = 'Support';
  static const String safetyTips = 'Safety Tips';
  static const String home = 'Home';
  static const String profile = 'Profile';
  static const String settings = 'Settings';

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
            const CustomDrawerHeader(),
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
                          return AlertDialog(
                            title: const Text('Confirm Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Logout'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
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

        final userRole = snapshot.data;
        final menuItems = _getMenuItemsByRole(context, userRole);

        return Column(
          children: [
            _buildMenuSection('MENU', menuItems.take(1).toList()),
            if (menuItems.length > 1) ...[
              const SizedBox(height: 24),
              _buildMenuSection(
                'FEATURES',
                menuItems.skip(1).take(menuItems.length - 2).toList(),
              ),
              const SizedBox(height: 24),
              _buildMenuSection(
                'OTHER',
                menuItems.skip(menuItems.length - 1).toList(),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildMenuSection(String title, List<DrawerItem> items) {
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
        ...items,
      ],
    );
  }

  void _handleNavigation(BuildContext context, String title, int index) {
    onIndexSelected(index);
    switch (title) {
      // Admin routes
      case analytics:
        AppRoutes.navigateToAnalytics(context);
        break;
      case customers:
        AppRoutes.navigateToCustomerManagement(context);
        break;
      case service:
        AppRoutes.navigateToServiceRequests(context);
        break;
      case inventory:
        AppRoutes.navigateToInventory(context);
        break;
      case finance:
        AppRoutes.navigateToFinance(context);
        break;
      case aiInsights:
        AppRoutes.navigateToAIInsights(context);
        break;
      case staff:
        AppRoutes.navigateToStaffManagement(context);
        break;

      // Manager routes
      case technician:
        AppRoutes.navigateToTechnicianManagement(context);
        break;
      case task:
        AppRoutes.navigateToTaskAssignment(context);
        break;
      case location:
        AppRoutes.navigateToLocationTracking(context);
        break;
      case stock:
        AppRoutes.navigateToStockManagement(context);
        break;

      // Technician routes
      case tasks:
        AppRoutes.navigateToMyTasks(context);
        break;
      case navigation:
        AppRoutes.navigateToTechnicianNavigation(context);
        break;
      case service:
        AppRoutes.navigateToServiceHistory(context);
        break;
      case offlineMode:
        AppRoutes.navigateToOfflineMode(context);
        break;
      case customerFeedback:
        AppRoutes.navigateToCustomerFeedback(context);
        break;

      // Client routes
      case dashboard:
        AppRoutes.navigateToDashboard(context);
        break;
      case extinguishers:
        AppRoutes.navigateToMyExtinguishers(context);
        break;
      case requestService:
        AppRoutes.navigateToRequestService(context);
        break;
      case payments:
        AppRoutes.navigateToPayments(context);
        break;
      case support:
        AppRoutes.navigateToSupport(context);
        break;
      case safetyTips:
        AppRoutes.navigateToSafetyTips(context);
        break;

      // Common routes
      case home:
        AppRoutes.navigateToHome(context);
        break;
      case profile:
        AppRoutes.navigateToProfile(context);
        break;
      case settings:
        AppRoutes.navigateToSettings(context);
        break;
      default:
        AppRoutes.navigateToHome(context);
    }
  }

  List<DrawerItem> _getMenuItemsByRole(BuildContext context, String? userRole) {
    List<DrawerItem> menuItems = [
      DrawerItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        title: dashboard,
        index: 0,
        isSelected: selectedIndex == 0,
        onTap: () => AppRoutes.navigateToDashboard(context),
      ),
    ];

    switch (userRole?.toLowerCase()) {
      case 'admin':
        menuItems.addAll(_adminMenuItems(context));
        break;
      case 'manager':
        menuItems.addAll(_managerMenuItems(context));
        break;
      case 'technician':
        menuItems.addAll(_technicianMenuItems(context));
        break;
      case 'client':
        menuItems.addAll(_clientMenuItems(context));
        break;
    }

    menuItems.add(_settingsMenuItem(context, menuItems.length));
    return menuItems;
  }

  List<DrawerItem> _adminMenuItems(BuildContext context) => [
        _createMenuItem(
            context, Icons.analytics_outlined, Icons.analytics, analytics, 1),
        _createMenuItem(
            context, Icons.group_outlined, Icons.group, customers, 2),
        _createMenuItem(
            context, Icons.assignment_outlined, Icons.assignment, service, 3),
        _createMenuItem(context, Icons.inventory_2_outlined, Icons.inventory_2,
            inventory, 4),
        _createMenuItem(
            context, Icons.payments_outlined, Icons.payments, finance, 5),
        _createMenuItem(
            context, Icons.analytics_outlined, Icons.analytics, aiInsights, 6),
        _createMenuItem(context, Icons.supervisor_account_outlined,
            Icons.supervisor_account, staff, 7),
      ];

  List<DrawerItem> _managerMenuItems(BuildContext context) => [
        _createMenuItem(
            context, Icons.people_outline, Icons.people, technician, 1),
        _createMenuItem(
            context, Icons.assignment_outlined, Icons.assignment, task, 2),
        _createMenuItem(context, Icons.map_outlined, Icons.map, location, 3),
        _createMenuItem(
            context, Icons.inventory_2_outlined, Icons.inventory_2, stock, 4),
      ];

  List<DrawerItem> _technicianMenuItems(BuildContext context) => [
        _createMenuItem(context, Icons.work_outline, Icons.work, tasks, 1),
        _createMenuItem(context, Icons.map_outlined, Icons.map, navigation, 2),
        _createMenuItem(
            context, Icons.history_outlined, Icons.history, service, 3),
        _createMenuItem(context, Icons.offline_bolt_outlined,
            Icons.offline_bolt, offlineMode, 4),
        _createMenuItem(context, Icons.rate_review_outlined, Icons.rate_review,
            customerFeedback, 5),
      ];

  List<DrawerItem> _clientMenuItems(BuildContext context) => [
        _createMenuItem(
            context, Icons.dashboard_outlined, Icons.dashboard, dashboard, 1),
        _createMenuItem(context, Icons.fire_extinguisher,
            Icons.fire_extinguisher, extinguishers, 2),
        _createMenuItem(
            context, Icons.history_outlined, Icons.history, service, 3),
        _createMenuItem(context, Icons.request_page_outlined,
            Icons.request_page, requestService, 4),
        _createMenuItem(
            context, Icons.payment_outlined, Icons.payment, payments, 5),
        _createMenuItem(
            context, Icons.support_outlined, Icons.support, support, 6),
        _createMenuItem(context, Icons.safety_check_outlined,
            Icons.safety_check, safetyTips, 7),
      ];

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

  DrawerItem _settingsMenuItem(BuildContext context, int index) => DrawerItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        title: 'Settings',
        index: index,
        isSelected: selectedIndex == index,
        onTap: () => AppRoutes.navigateToSettings(context),
      );
}
