import 'package:firetrack360/ui/pages/home/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Settings',
        showBackButton: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context: context,
              title: 'Profile',
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Profile Settings',
                  subtitle: 'Update your personal information',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Configure your notification preferences',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.security_outlined,
                  title: 'Security',
                  subtitle: 'Manage your security settings',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'App Settings',
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.color_lens_outlined,
                  title: 'Theme',
                  subtitle: 'Customize app appearance',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.language_outlined,
                  title: 'Language',
                  subtitle: 'Change app language',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.data_usage_outlined,
                  title: 'Data Usage',
                  subtitle: 'Manage data and storage',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'Support',
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Bug',
                  subtitle: 'Help us improve the app',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App information and version',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.zero,
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: Colors.deepPurple,
          size: 26,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.deepPurple,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      endIndent: 20,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          // Handle logout logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'LOGOUT',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
