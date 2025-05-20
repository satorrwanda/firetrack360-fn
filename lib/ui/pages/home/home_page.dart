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

    // Determine colors based on theme brightness, but keeping deepPurple prominent
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarColor = isDarkMode
        ? Colors.deepPurple.shade900
        : Colors.deepPurple; // Darker deepPurple for dark mode app bar
    final gradientStartColor = isDarkMode
        ? Colors.deepPurple.shade900
        : Colors.deepPurple.shade700; // Darker deepPurple gradient start
    final gradientEndColor = isDarkMode
        ? Colors.black
        : Colors.deepPurple.shade400; // Fade to black or a mid-range deepPurple
    final cardBackgroundColor = isDarkMode
        ? Colors.deepPurple.shade800
        : Colors.white; // Darker deepPurple for cards
    final textColor = isDarkMode ? Colors.white : Colors.black87; // Text color
    final secondaryTextColor = isDarkMode
        ? Colors.white70
        : Colors.grey.shade600; // Secondary text color

    return AuthGateway(
      child: Scaffold(
        extendBody: true, // <--- ADDED THIS LINE
        appBar: CustomAppBar(
          title: l10n.homePageTitle,
          backgroundColor: appBarColor,
          actions: [
            _buildNotificationIcon(
                context, l10n, isDarkMode), // Pass isDarkMode
            const SizedBox(width: 8),
          ],
        ),
        drawer: CustomDrawer(
          selectedIndex: selectedIndex.value,
          onIndexSelected: (index) => selectedIndex.value = index,
        ),
        bottomNavigationBar: CustomBottomNav(userRole: authState.userRole),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradientStartColor,
                gradientEndColor,
              ],
            ),
          ),
          child: SafeArea(
            // Removed top padding from SafeArea
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  16.0, 0, 16.0, 0), // Adjusted padding
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0), // Added space at the top
                    _buildWelcomeSection(
                        context,
                        l10n,
                        cardBackgroundColor,
                        textColor,
                        secondaryTextColor,
                        isDarkMode), // Pass colors and isDarkMode
                    const SizedBox(height: 24),
                    _buildQuickActions(
                        context,
                        l10n,
                        cardBackgroundColor,
                        textColor,
                        secondaryTextColor,
                        isDarkMode), // Pass colors and isDarkMode
                    const SizedBox(height: 24),
                    _buildStatusSection(
                        context,
                        authState,
                        l10n,
                        cardBackgroundColor,
                        textColor,
                        secondaryTextColor,
                        isDarkMode), // Pass colors and isDarkMode
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom +
                            16), // Add padding at the bottom considering bottom nav bar height
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(
      BuildContext context,
      S l10n,
      Color cardBackgroundColor,
      Color textColor,
      Color secondaryTextColor,
      bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.4)
                : Colors.black
                    .withOpacity(0.1), // More prominent shadow in dark mode
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
            l10n.welcomeBackTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeBackSubtitle,
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context,
      S l10n,
      Color cardBackgroundColor,
      Color textColor,
      Color secondaryTextColor,
      bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActionsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.inventory,
                title: l10n.actionCardInventory,
                color: isDarkMode
                    ? Colors.deepPurple.shade300
                    : Colors.deepPurple, // Use deepPurple shades
                cardBackgroundColor:
                    cardBackgroundColor, // Pass card background color
                textColor: textColor, // Pass text color
                isDarkMode: isDarkMode, // Pass isDarkMode
                onTap: () => Navigator.pushNamed(context, AppRoutes.inventory),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.miscellaneous_services,
                title: l10n.actionCardServices,
                color: isDarkMode
                    ? Colors.deepPurple.shade200
                    : Colors.deepPurple.shade300, // Use deepPurple shades
                cardBackgroundColor:
                    cardBackgroundColor, // Pass card background color
                textColor: textColor, // Pass text color
                isDarkMode: isDarkMode, // Pass isDarkMode
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
                title: l10n.actionCardSettings,
                color: isDarkMode
                    ? Colors.deepPurple.shade400
                    : Colors.deepPurple.shade400, // Use deepPurple shades
                cardBackgroundColor:
                    cardBackgroundColor, // Pass card background color
                textColor: textColor, // Pass text color
                isDarkMode: isDarkMode, // Pass isDarkMode
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.notifications,
                title: l10n.actionCardNotifications,
                color: isDarkMode
                    ? Colors.deepPurple.shade500
                    : Colors.deepPurple.shade500, // Use deepPurple shades
                cardBackgroundColor:
                    cardBackgroundColor, // Pass card background color
                textColor: textColor, // Pass text color
                isDarkMode: isDarkMode, // Pass isDarkMode
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
                title: l10n.actionCardNavigation,
                color: isDarkMode
                    ? Colors.deepPurple.shade600
                    : Colors.deepPurple.shade600, // Use deepPurple shades
                cardBackgroundColor:
                    cardBackgroundColor, // Pass card background color
                textColor: textColor, // Pass text color
                isDarkMode: isDarkMode, // Pass isDarkMode
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
    required String title,
    required Color color,
    required Color cardBackgroundColor, // Receive card background color
    required Color textColor, // Receive text color
    required bool isDarkMode, // Receive isDarkMode
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackgroundColor, // Use the passed card background color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black
                    .withOpacity(0.05), // More prominent shadow in dark mode
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
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor, // Use the passed text color
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
      BuildContext context,
      AuthState authState,
      S l10n,
      Color cardBackgroundColor,
      Color textColor,
      Color secondaryTextColor,
      bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBackgroundColor, // Use the passed card background color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.4)
                : Colors.black
                    .withOpacity(0.1), // More prominent shadow in dark mode
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
            l10n.statusTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor, // Use the passed text color
            ),
          ),
          const SizedBox(height: 12),
          if (authState.userRole != null)
            Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 20,
                  color: isDarkMode
                      ? Colors.deepPurple.shade300
                      : Colors.deepPurple, // Use deepPurple shade
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.roleLabel}: ${authState.userRole}',
                  style: TextStyle(
                    color:
                        secondaryTextColor, // Use the passed secondary text color
                    fontSize: 14,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context, S l10n, bool isDarkMode) {
    return IconButton(
      icon: Stack(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.white, // Keep icon color consistent for the app bar
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red.shade600, // Red notification badge
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
