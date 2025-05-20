import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/providers/locale_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Use HookConsumerWidget
class CustomBottomNav extends HookConsumerWidget {
  final String? userRole;
  static String currentLabel = 'Home';

  const CustomBottomNav({
    super.key,
    this.userRole,
  });

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'rw':
        return 'Kinyarwanda';
      default:
        return code.toUpperCase();
    }
  }

  void _showLanguageSelectionModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          // Adjust modal background color for themes if needed
          color: Theme.of(context).bottomSheetTheme.modalBackgroundColor ??
              Theme.of(context).canvasColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  S.of(context).selectLanguageTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        // Adjust text color for themes
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                ),
              ),
              Divider(color: Theme.of(context).dividerColor), // Add a divider
              ...S.supportedLocales.map((locale) {
                final isSelected =
                    Localizations.localeOf(context).languageCode ==
                        locale.languageCode;
                return ListTile(
                  title: Text(
                    _getLanguageName(locale.languageCode),
                    style: TextStyle(
                      // Adjust text color for themes and selection state
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primary // Highlight selected language
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(localeProvider.notifier).setLocale(locale);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  // Build method for HookConsumerWidget
  Widget build(BuildContext context, WidgetRef ref) {
    // Now you can use hooks AND access ref
    String initialLabel = CustomBottomNav.currentLabel;
    if (!['Home', 'Profile', 'Language'].contains(initialLabel)) {
      initialLabel = 'Home';
      CustomBottomNav.currentLabel = 'Home';
    }

    final selectedLabel = useState(initialLabel); // You can still use useState
    final navigatorState = Navigator.of(context);
    final l10n = S.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors similar to the drawer, adapted for bottom nav
    final startColor =
        isDarkMode ? Colors.deepPurple.shade900 : Colors.deepPurple.shade700;
    final endColor = isDarkMode ? Colors.black : Colors.deepPurple.shade400;
    final selectedItemColor = isDarkMode
        ? Colors.white
        : Colors.deepPurple; // White for selected in dark mode
    final unselectedItemColor = isDarkMode
        ? Colors.white60
        : Colors.grey.shade600; // Less prominent white in dark mode

    void handleNavigation(String label) {
      selectedLabel.value = label; // Update hook state
      CustomBottomNav.currentLabel =
          label; // Keep static updated if needed elsewhere

      switch (label) {
        case 'Home':
          // Use pushReplacementNamed to avoid stacking Home pages
          if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
            Navigator.popUntil(
                context, ModalRoute.withName(AppRoutes.home)); // Pop until home
            // If not already on home, navigate to home
            if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
              navigatorState.pushReplacementNamed(AppRoutes.home);
            }
          }
          break;
        case 'Profile':
          // Pop all routes until home, then push profile
          Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
          navigatorState.pushNamed(AppRoutes.profile);
          break;
        case 'Language':
          _showLanguageSelectionModal(context, ref); // Pass ref to modal
          // Do not change the selected label state for the modal
          break;
      }
    }

    final items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: l10n.bottomNavHome,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: l10n.bottomNavProfile,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.language_outlined),
        activeIcon: const Icon(Icons.language),
        label: l10n.bottomNavLanguage,
      ),
    ];

    final currentIndex =
        ['Home', 'Profile', 'Language'].indexOf(selectedLabel.value);

    return Material(
      elevation: 8, // Keep a subtle elevation
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              startColor,
              endColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(isDarkMode ? 0.4 : 0.1), // Adjust shadow opacity
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              final tappedLabel = ['Home', 'Profile', 'Language'][index];
              handleNavigation(tappedLabel);
            },
            selectedItemColor:
                selectedItemColor, // Use theme-based selected color
            unselectedItemColor:
                unselectedItemColor, // Use theme-based unselected color
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0, // Remove elevation here as Container provides it
            backgroundColor: Colors
                .transparent, // Make background transparent to show gradient
            items: items,
          ),
        ),
      ),
    );
  }
}
