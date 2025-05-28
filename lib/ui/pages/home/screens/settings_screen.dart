import 'package:firetrack360/routes/app_routes.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/auth/widgets/language_toggle.dart';
import 'package:firetrack360/ui/pages/home/widgets/custom_app_bar.dart';
import 'package:firetrack360/ui/pages/home/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor =
        isDark ? Colors.deepPurple.shade800 : Colors.deepPurple.shade50;

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
              cardColor: cardColor,
              children: [
                _buildSettingsTile(
                  context: context,
                  icon: Icons.person_outline,
                  title: l10n.profileSettingsTitle,
                  subtitle: l10n.profileSettingsSubtitle,
                  cardColor: cardColor,
                  onTap: () {
                    AppRoutes.navigateToProfile(context);
                  },
                ),
                _buildDivider(context),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: l10n.appSettingsSectionTitle,
              cardColor: cardColor,
              children: [
                _buildLanguageTogglerTile(context, l10n, cardColor),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: LogoutButton(
                onLogout: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      final dialogL10n = S.of(context);
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
                            : Colors.deepPurple.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 48,
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                dialogL10n.confirmLogoutTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.deepPurple,
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
                                      : Colors.deepPurple.shade800,
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
                                      foregroundColor: Colors.deepPurple,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                    ),
                                    child: Text(dialogL10n.cancelButton),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTogglerTile(
      BuildContext context, S l10n, Color cardColor) {
    final theme = Theme.of(context);
    final isTileDark = theme.brightness == Brightness.dark;
    final textColor = isTileDark ? Colors.white : Colors.deepPurple.shade900;
    final subtitleColor =
        isTileDark ? Colors.white70 : Colors.deepPurple.shade700;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.language,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        title: Text(
          l10n.languageTitle,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.languageSubtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: isTileDark
                      ? Colors.deepPurple.shade700
                      : Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.deepPurple.withOpacity(0.3),
                  ),
                ),
                child: const LanguageToggler(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Color cardColor,
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
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
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
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isTileDark = theme.brightness == Brightness.dark;
    final textColor = isTileDark ? Colors.white : Colors.deepPurple.shade900;
    final subtitleColor =
        isTileDark ? Colors.white70 : Colors.deepPurple.shade700;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: subtitleColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.deepPurple,
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      endIndent: 16,
      color: Colors.deepPurple.withOpacity(0.2),
    );
  }
}
