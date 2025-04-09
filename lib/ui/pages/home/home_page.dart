import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/routes/auth_gateway.dart';
import 'widgets/custom_drawer.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/custom_app_bar.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = useAuth();
    final selectedIndex = useState(0);

    // Handle errors globally
    useEffect(() {
      if (authState.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }, [authState.error]);

    return AuthGateway(
      child: Scaffold(
        appBar: CustomAppBar(
          title: ('Home'),
          actions: [
            _buildNotificationIcon(),
            const SizedBox(width: 8),
          ],
        ),
        drawer: CustomDrawer(
          selectedIndex: selectedIndex.value,
          onIndexSelected: (index) => selectedIndex.value = index,
        ),
        body: _buildBody(context, authState),
        bottomNavigationBar: CustomBottomNav(userRole: authState.userRole),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthState authState) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[50]!, Colors.white],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildStatusSection(context, authState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your fire safety equipment efficiently',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildActionCard(
              context,
              icon: Icons.inventory,
              title: 'Inventory',
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/inventory'),
            )),
            Expanded(
                child: _buildActionCard(
              context,
              icon: Icons.miscellaneous_services,
              title: 'Services',
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/service-requests'),
            )),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildActionCard(
              context,
              icon: Icons.payment,
              title: 'Payments & Billing',
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/finance'),
            )),
            Expanded(
                child: _buildActionCard(
              context,
              icon: Icons.map,
              title: 'Navigation',
              color: Colors.purple,
              onTap: () => Navigator.pushNamed(context, '/navigation'),
            )),
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
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, AuthState authState) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (authState.userRole != null)
              Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 20,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Role: ${authState.userRole}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.notifications_outlined),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
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
      onPressed: () {
        // Handle notification tap
      },
    );
  }
}
