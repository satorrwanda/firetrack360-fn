import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/auth/widgets/language_toggle.dart';
import 'package:firetrack360/ui/pages/home/widgets/custom_app_bar.dart';
import 'package:firetrack360/ui/pages/home/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// SettingsScreen needs to be a ConsumerWidget to use Riverpod
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add WidgetRef ref
    final l10n = S.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : Colors.grey[50],
      appBar: CustomAppBar(
        title: l10n.settingsTitle,
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
              title: l10n.profileSettingsSectionTitle,
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.person_outline,
                  title: l10n.profileSettingsTitle,
                  subtitle: l10n.profileSettingsSubtitle,
                  onTap: () {
                    AppRoutes.navigateToProfile(context);
                  },
                ),
                _buildDivider(context),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.lock_outline,
                  title: l10n.changePasswordTitle,
                  subtitle: l10n.changePasswordSubtitle,
                  onTap: () {
                    // TODO: Navigate to Change Password Screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: l10n.appSettingsSectionTitle,
              children: [
                _buildLanguageTogglerTile(context, l10n),
              ],
            ),
            const SizedBox(height: 24),
            LogoutButton(
              onLogout: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    final dialogL10n = S.of(context)!;
                    final dialogTheme = Theme.of(context);
                    final isDialogDark =
                        dialogTheme.brightness == Brightness.dark;

                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 5,
                      backgroundColor: isDialogDark
                          ? Colors.deepPurple.shade900
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              size: 48,
                              color: dialogTheme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              dialogL10n.confirmLogoutTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: dialogTheme.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              dialogL10n.confirmLogoutMessage,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDialogDark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  style: TextButton.styleFrom(
                                    foregroundColor: isDialogDark
                                        ? Colors.white70
                                        : Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  child: Text(dialogL10n.cancelButton),
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
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    dialogL10n.logoutButton,
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

                if (shouldLogout == true) {
                  await AuthService.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTogglerTile(BuildContext context, S l10n) {
    final theme = Theme.of(context);
    final isTileDark = theme.brightness == Brightness.dark;

    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isTileDark
                ? Colors.deepPurple.withOpacity(0.2)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.language_outlined,
            color: Colors.deepPurple,
            size: 26,
          ),
        ),
        title: Text(
          l10n.languageTitle,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: isTileDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          l10n.languageSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: isTileDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        trailing: const LanguageToggler());
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final isSectionDark = theme.brightness == Brightness.dark;

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
            color: isSectionDark ? Colors.deepPurple.shade800 : Colors.white,
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
    final theme = Theme.of(context);
    final isTileDark = theme.brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isTileDark
              ? Colors.deepPurple.withOpacity(0.2)
              : Colors.grey.shade100,
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
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: isTileDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isTileDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.deepPurple,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      endIndent: 20,
      color: theme.dividerColor,
    );
  }
}
