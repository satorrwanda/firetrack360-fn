import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/routes/auth_gateway.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/custom_app_bar.dart';
import 'package:firetrack360/generated/l10n.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = useAuth();
    final selectedIndex = useState(0);
    final l10n = S.of(context)!;

    // Handle errors globally
    useEffect(() {
      if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(authState.error!)),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      return null;
    }, [authState.error]);

    return AuthGateway(
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.homePageTitle,
          backgroundColor: Colors.deepPurple,
          actions: [
            _buildNotificationIcon(context, l10n), // Pass l10n
            const SizedBox(width: 8),
          ],
        ),
        // CustomDrawer and CustomBottomNav should handle their own localization internally
        drawer: CustomDrawer(
          selectedIndex: selectedIndex.value,
          onIndexSelected: (index) => selectedIndex.value = index,
        ),
        bottomNavigationBar: CustomBottomNav(userRole: authState.userRole),
        body: _buildBody(context, authState, l10n), // Pass l10n to body builder
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthState authState, S l10n) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context, l10n), // Pass l10n
              const SizedBox(height: 24),
              _buildQuickActions(context, l10n), // Pass l10n
              const SizedBox(height: 24),
              _buildStatusSection(context, authState, l10n), // Pass l10n
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, S l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.welcomeBackTitle, // Localized welcome title
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeBackSubtitle, // Localized welcome subtitle
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, S l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActionsTitle, // Localized quick actions title
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.inventory,
                title: l10n.actionCardInventory, // Localized title
                color: Colors.deepPurple,
                onTap: () => Navigator.pushNamed(context, AppRoutes.inventory),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.miscellaneous_services,
                title: l10n.actionCardServices, // Localized title
                color: Colors.deepPurple.shade300,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.serviceRequests),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.settings,
                title: l10n.actionCardSettings, // Localized title
                color: Colors.deepPurple.shade400,
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.notifications,
                title: l10n.actionCardNotifications, // Localized title
                color: Colors.deepPurple.shade500,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.notification),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.map,
                title: l10n.actionCardNavigation, // Localized title
                color: Colors.deepPurple.shade600,
                onTap: () => Navigator.pushNamed(context, AppRoutes.navigation),
              ),
            ),
            Expanded(
              child: const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title, // This title is already localized when passed in
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  title, // Use the localized title passed in
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(
      BuildContext context, AuthState authState, S l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statusTitle, // Localized status title
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (authState.userRole != null)
            Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 20,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.roleLabel}: ${authState.userRole}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, S l10n) {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(
            Icons.notifications_outlined,
            color: Colors.white,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
            ),
          ),
        ],
      ),
      tooltip: l10n.notificationsTooltip,
      onPressed: () {
        AppRoutes.navigateToNotification(context);
      },
    );
  }
}
