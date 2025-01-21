import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/home/widgets/custom_drawer_header.dart';
import 'package:firetrack360/ui/pages/home/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'drawer_item.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexSelected;
  final VoidCallback onLogout;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onIndexSelected,
    required this.onLogout,
  });

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
                    LogoutButton(onLogout: onLogout),
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
    switch (title.toLowerCase()) {
      // Admin routes
      case 'analytics & reports':
        AppRoutes.navigateToAnalytics(context);
        break;
      case 'customer management':
        AppRoutes.navigateToCustomerManagement(context);
        break;
      case 'service requests':
        AppRoutes.navigateToServiceRequests(context);
        break;
      case 'inventory':
        AppRoutes.navigateToInventory(context);
        break;
      case 'finance':
        AppRoutes.navigateToFinance(context);
        break;
      case 'ai insights':
        AppRoutes.navigateToAIInsights(context);
        break;
      case 'staff management':
        AppRoutes.navigateToStaffManagement(context);
        break;

      // Manager routes
      case 'technician management':
        AppRoutes.navigateToTechnicianManagement(context);
        break;
      case 'task assignment':
        AppRoutes.navigateToTaskAssignment(context);
        break;
      case 'location tracking':
        AppRoutes.navigateToLocationTracking(context);
        break;
      case 'service feedback':
        AppRoutes.navigateToServiceFeedback(context);
        break;
      case 'stock management':
        AppRoutes.navigateToStockManagement(context);
        break;

      // Technician routes
      case 'my tasks':
        AppRoutes.navigateToMyTasks(context);
        break;
      case 'navigation':
        AppRoutes.navigateToTechnicianNavigation(context);
        break;
      case 'service history':
        AppRoutes.navigateToServiceHistory(context);
        break;
      case 'offline mode':
        AppRoutes.navigateToOfflineMode(context);
        break;
      case 'customer feedback':
        AppRoutes.navigateToCustomerFeedback(context);
        break;

      // Client routes
      case 'my dashboard':
        AppRoutes.navigateToDashboard(context);
        break;
      case 'my extinguishers':
        AppRoutes.navigateToMyExtinguishers(context);
        break;
      case 'request service':
        AppRoutes.navigateToRequestService(context);
        break;
      case 'payments & billing':
        AppRoutes.navigateToPayments(context);
        break;
      case 'support':
        AppRoutes.navigateToSupport(context);
        break;
      case 'safety tips':
        AppRoutes.navigateToSafetyTips(context);
        break;

      // Common routes
      case 'dashboard':
        AppRoutes.navigateToHome(context);
        break;
      case 'profile':
        AppRoutes.navigateToProfile(context);
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
        title: 'Dashboard',
        index: 0,
        isSelected: selectedIndex == 0,
        onTap: () => _handleNavigation(context, 'Dashboard', 0),
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
        _createMenuItem(context, Icons.analytics_outlined, Icons.analytics,
            'Analytics & Reports', 1),
        _createMenuItem(context, Icons.group_outlined, Icons.group,
            'Customer Management', 2),
        _createMenuItem(context, Icons.assignment_outlined, Icons.assignment,
            'Service Requests', 3),
        _createMenuItem(context, Icons.inventory_2_outlined, Icons.inventory_2,
            'Inventory', 4),
        _createMenuItem(
            context, Icons.payments_outlined, Icons.payments, 'Finance', 5),
        _createMenuItem(context, Icons.analytics_outlined, Icons.analytics,
            'AI Insights', 6),
        _createMenuItem(context, Icons.supervisor_account_outlined,
            Icons.supervisor_account, 'Staff Management', 7),
      ];

  List<DrawerItem> _managerMenuItems(BuildContext context) => [
        _createMenuItem(context, Icons.people_outline, Icons.people,
            'Technician Management', 1),
        _createMenuItem(context, Icons.assignment_outlined, Icons.assignment,
            'Task Assignment', 2),
        _createMenuItem(
            context, Icons.map_outlined, Icons.map, 'Location Tracking', 3),
        _createMenuItem(context, Icons.reviews_outlined, Icons.reviews,
            'Service Feedback', 4),
        _createMenuItem(context, Icons.inventory_2_outlined, Icons.inventory_2,
            'Stock Management', 5),
      ];

  List<DrawerItem> _technicianMenuItems(BuildContext context) => [
        _createMenuItem(context, Icons.work_outline, Icons.work, 'My Tasks', 1),
        _createMenuItem(context, Icons.qr_code_scanner_outlined,
            Icons.qr_code_scanner, 'Scan QR', 2),
        _createMenuItem(
            context, Icons.map_outlined, Icons.map, 'Navigation', 3),
        _createMenuItem(context, Icons.history_outlined, Icons.history,
            'Service History', 4),
        _createMenuItem(context, Icons.offline_bolt_outlined,
            Icons.offline_bolt, 'Offline Mode', 5),
        _createMenuItem(context, Icons.rate_review_outlined, Icons.rate_review,
            'Customer Feedback', 6),
      ];

  List<DrawerItem> _clientMenuItems(BuildContext context) => [
        _createMenuItem(context, Icons.dashboard_outlined, Icons.dashboard,
            'My Dashboard', 1),
        _createMenuItem(context, Icons.fire_extinguisher,
            Icons.fire_extinguisher, 'Extinguishers', 2),
        _createMenuItem(context, Icons.history_outlined, Icons.history,
            'Service History', 3),
        _createMenuItem(context, Icons.request_page_outlined,
            Icons.request_page, 'Request Service', 4),
        _createMenuItem(context, Icons.payment_outlined, Icons.payment,
            'Payments & Billing', 5),
        _createMenuItem(
            context, Icons.support_outlined, Icons.support, 'Support', 6),
        _createMenuItem(context, Icons.safety_check_outlined,
            Icons.safety_check, 'Safety Tips', 7),
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
        onTap: () => _handleNavigation(context, 'Settings', index),
      );
}